package main

import (
	"common"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path"
)

const (
	step_implementation_file = "step_implementation.rb"
	step_implementations_dir = "step_implementations"
	ruby_properties_file     = "ruby.properties"
	ruby_directory           = "ruby"
	gauge_runtime_ruby_file  = "gauge-runtime.rb"
	lib_dir                  = "lib"
)

var projectRoot = ""
var start = flag.Bool("start", false, "Start the gauge ruby runner")
var initialize = flag.Bool("init", false, "Initialize the gauge ruby runner")

func getProjectRoot() string {
	pwd, err := common.GetProjectRoot()
	if err != nil {
		panic(err)
	}

	return pwd
}

type initializerFunc func()

func showMessage(action, filename string) {
	fmt.Printf(" %s  %s\n", action, filename)
}

func createStepImplementationsDirectory() {
	createDirectory(path.Join("step_implementations"))
}

func createDirectory(filePath string) {
	showMessage("create", filePath)
	if !common.DirExists(filePath) {
		err := os.MkdirAll(filePath, 0755)
		if err != nil {
			fmt.Printf("Failed to make directory. %s\n", err.Error())
		}
	} else {
		showMessage("skip", filePath)
	}
}

func createStepImplementationFile() {
	destFile := path.Join(step_implementations_dir, step_implementation_file)
	showMessage("create", destFile)
	if common.FileExists(destFile) {
		showMessage("skip", destFile)
	} else {
		srcFile, err := common.GetSkeletonFilePath(path.Join(ruby_directory, step_implementation_file))
		if err != nil {
			showMessage("error", fmt.Sprintf("Failed to find %s. %s", step_implementation_file, err.Error()))
			return
		}
		err = common.CopyFile(srcFile, destFile)
		if err != nil {
			showMessage("error", fmt.Sprintf("Failed to copy %s. %s", srcFile, err.Error()))
		}
	}
}

func createRubyPropertiesFile() {
	destFile := path.Join("env", "default", ruby_properties_file)
	showMessage("create", destFile)
	if common.FileExists(destFile) {
		showMessage("skip", destFile)
	} else {
		srcFile, err := common.GetSkeletonFilePath(path.Join("env", ruby_properties_file))
		if err != nil {
			showMessage("error", fmt.Sprintf("Failed to find env/%s. %s", ruby_properties_file, err.Error()))
			return
		}
		err = common.CopyFile(srcFile, destFile)
		if err != nil {
			showMessage("error", fmt.Sprintf("Failed to copy %s. %s", srcFile, err.Error()))
		}
	}
}

func getInstallationPath() string {
	libsPath := common.GetLibsPath()
	return path.Join(libsPath, ruby_directory)
}

func printUsage() {
	flag.PrintDefaults()
	os.Exit(2)
}

func runCommand(cmdName string, arg ...string) {
	cmd := exec.Command(cmdName, arg...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	//TODO: move to logs
	//fmt.Println(cmd.Args)
	var err error
	err = cmd.Start()
	if err != nil {
		fmt.Printf("Failed to start Gauge Ruby runner. %s\n", err.Error())
		os.Exit(1)
	}
	err = cmd.Wait()
	if err != nil {
		fmt.Printf("Failed to start Gauge Ruby runner. %s\n", err.Error())
		os.Exit(1)
	}
}

func main() {
	flag.Parse()
	if *start {
		os.Chdir(getProjectRoot())
		runCommand("ruby", "-e", "require 'gauge-runtime'")
	} else if *initialize {
		funcs := []initializerFunc{createStepImplementationsDirectory, createStepImplementationFile, createRubyPropertiesFile}
		for _, f := range funcs {
			f()
		}
	} else {
		printUsage()
	}
}
