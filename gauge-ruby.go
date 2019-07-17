// Copyright 2015 ThoughtWorks, Inc.

// This file is part of Gauge-Ruby.

// Gauge-Ruby is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Gauge-Ruby is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Gauge-Ruby.  If not, see <http://www.gnu.org/licenses/>.

package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path"

	"github.com/getgauge/common"
)

const (
	step_implementation_file = "step_implementation.rb"
	step_implementations_dir = "step_implementations"
	gem_file                 = "Gemfile"
	ruby_properties_file     = "ruby.properties"
	skelDir                  = "skel"
	envDir                   = "env"
)

var start = flag.Bool("start", false, "Start the gauge ruby runner")
var initialize = flag.Bool("init", false, "Initialize the gauge ruby runner")
var pluginDir = ""
var projectRoot = ""

type logger struct {
	LogLevel string `json:"logLevel"`
	Message  string `json:"message"`
}

type initializerFunc func()

func logMessage(level, text string) {
	c := &logger{LogLevel: level, Message: text}
	if b, err := json.Marshal(c); err != nil {
		fmt.Println(text)
	} else {
		fmt.Println(string(b))
	}
}

func showMessage(action, filename string) string {
	return fmt.Sprintf(" %s  %s\n", action, filename)
}

func createStepImplementationsDirectory() {
	createDirectory(path.Join(projectRoot, "step_implementations"))
}

func createEnvDir() {
	createDirectory(path.Join(projectRoot, "env", "default"))
}

func createDirectory(filePath string) {
	logMessage("info", showMessage("create", filePath))
	if !common.DirExists(filePath) {
		err := os.MkdirAll(filePath, 0755)
		if err != nil {
			logMessage("error", fmt.Sprintf("Failed to make directory. %s\n", err.Error()))
		}
	} else {
		logMessage("info", showMessage("skip", filePath))
	}
}

func createStepImplementationFile() {
	destFile := path.Join(projectRoot, step_implementations_dir, step_implementation_file)
	logMessage("info", showMessage("create", destFile))
	if common.FileExists(destFile) {
		logMessage("info", showMessage("skip", destFile))
	} else {
		srcFile := path.Join(skelDir, step_implementation_file)
		err := common.CopyFile(srcFile, destFile)
		if err != nil {
			logMessage("error", fmt.Sprintf("Failed to copy %s. %s", srcFile, err.Error()))
		}
	}
}

func createOrAppendToGemFile() {
	destFile := path.Join(projectRoot, gem_file)
	srcFile := path.Join(skelDir, gem_file)
	logMessage("info", showMessage("create", destFile))
	if !common.FileExists(destFile) {
		err := common.CopyFile(srcFile, destFile)
		if err != nil {
			logMessage("error", fmt.Sprintf("Failed to copy %s. %s", srcFile, err.Error()))
		}
	}
	logMessage("info", showMessage("append", destFile))
	f, err := os.OpenFile(destFile, os.O_APPEND|os.O_WRONLY, 0666)
	if err != nil {
		panic(err)
	}

	defer f.Close()

	version, err := common.GetGaugePluginVersion("ruby")
	if err != nil {
		panic(err)
	}

	if _, err = f.WriteString(fmt.Sprintf("gem 'gauge-ruby', '~>%s', :group => [:development, :test]\n", version)); err != nil {
		panic(err)
	}
}

func createRubyPropertiesFile() {
	destFile := path.Join(projectRoot, envDir, "default", ruby_properties_file)
	logMessage("info", showMessage("create", destFile))
	if common.FileExists(destFile) {
		logMessage("info", showMessage("skip", destFile))
	} else {
		srcFile := path.Join(skelDir, envDir, ruby_properties_file)
		err := common.CopyFile(srcFile, destFile)
		if err != nil {
			logMessage("error", fmt.Sprintf("Failed to copy %s. %s", srcFile, err.Error()))
		}
	}
}

func createOrAppendGitignore() {
	destFile := path.Join(projectRoot, ".gitignore")
	srcFile := path.Join(pluginDir, skelDir, ".gitignore")
	logMessage("info", showMessage("create", destFile))
	if err := common.AppendToFile(srcFile, destFile); err != nil {
		logMessage("error", err.Error())
	}
}

func printUsage() {
	flag.PrintDefaults()
	os.Exit(2)
}

func runCommand(cmdName string, arg ...string) error {
	cmd := exec.Command(cmdName, arg...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	//TODO: move to logs
	//fmt.Println(cmd.Args)
	err := cmd.Run()
	return err
}

func main() {
	flag.Parse()
	var err error
	pluginDir, err = os.Getwd()
	if err != nil {
		logMessage("fatal", fmt.Sprintf("Failed to find current working directory: %s \n", err))
		os.Exit(1)
	}
	projectRoot = os.Getenv(common.GaugeProjectRootEnv)
	if projectRoot == "" {
		fmt.Printf("Could not find %s env. Ruby Runner exiting...", common.GaugeProjectRootEnv)
		os.Exit(1)
	}
	if *start {
		os.Chdir(projectRoot)
		err = runCommand("bundle", "exec", "ruby", "-e", "require 'gauge_runtime'")
		if err != nil {
			logMessage("fatal", fmt.Sprintf("Ruby runner Failed. Reason: %s\n", err.Error()))
			os.Exit(1)
		}
	} else if *initialize {
		funcs := []initializerFunc{createStepImplementationsDirectory, createStepImplementationFile, createEnvDir, createRubyPropertiesFile, createOrAppendToGemFile, createOrAppendGitignore}
		for _, f := range funcs {
			f()
		}
		os.Chdir(projectRoot)
		fmt.Printf("Running bundle install.. in %s\n", projectRoot)
		err = runCommand("bundle", "install")
		if err != nil {
			logMessage("error", fmt.Sprintf("bundle install Failed. Reason: %s\nConsider running `bundle install` again.\n", err.Error()))
		}
	} else {
		printUsage()
	}
}
