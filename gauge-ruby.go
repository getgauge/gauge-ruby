package main

import (
	"github.com/getgauge/common"
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
	skelDir                  = "skel"
	envDir                   = "env"
)

var start = flag.Bool("start", false, "Start the gauge ruby runner")
var initialize = flag.Bool("init", false, "Initialize the gauge ruby runner")
var pluginDir = ""
var projectRoot = ""

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
	createDirectory(path.Join(projectRoot, "step_implementations"))
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
	destFile := path.Join(projectRoot, step_implementations_dir, step_implementation_file)
	showMessage("create", destFile)
	if common.FileExists(destFile) {
		showMessage("skip", destFile)
	} else {
		srcFile := path.Join(skelDir, step_implementation_file)
		err := common.CopyFile(srcFile, destFile)
		if err != nil {
			showMessage("error", fmt.Sprintf("Failed to copy %s. %s", srcFile, err.Error()))
		}
	}
}

func createRubyPropertiesFile() {
	destFile := path.Join(projectRoot, envDir, "default", ruby_properties_file)
	showMessage("create", destFile)
	if common.FileExists(destFile) {
		showMessage("skip", destFile)
	} else {
		srcFile := path.Join(skelDir, envDir, ruby_properties_file)
		err := common.CopyFile(srcFile, destFile)
		if err != nil {
			showMessage("error", fmt.Sprintf("Failed to copy %s. %s", srcFile, err.Error()))
		}
	}
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
	var err error
	pluginDir, err = os.Getwd()
	if err != nil {
		fmt.Printf("Failed to find current working directory: %s \n", err)
		os.Exit(1)
	}
	projectRoot = os.Getenv("gauge_project_root")
	if projectRoot == "" {
		fmt.Println("Could not find gauge_project_root env. Java Runner exiting...")
		os.Exit(1)
	}

	if *start {
		os.Chdir(projectRoot)
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
