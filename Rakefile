=begin
 *  Copyright (c) ThoughtWorks, Inc.
 *  Licensed under the Apache License, Version 2.0
 *  See LICENSE.txt in the project root for license information.
=end
require 'rspec/core/rake_task'
require 'yard'
require "bundler/gem_tasks"
require 'zip'
require 'rake/clean'

PLUGIN_VERSION=JSON.parse(File.read('ruby.json'))['version']
ARCH_MAP = {"amd64" => "x86_64", "arm64" => "arm64"}

RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new

task :default => [:spec]

desc "Fetch github.com/getgauge/common"
task :fetch_common do
    sh "go get -u -d github.com/getgauge/common"
end

desc "Compile gauge-ruby.go for current OS/Arch"
task :compile => [:fetch_common, :build] do
    sh "go build -mod=readonly -o pkg/#{binary_name(nil)} gauge-ruby.go"
end

desc "X-Compile gauge-ruby.go for all supported OS/Arch"
task :xcompile => [:fetch_common, :build] do
    run_for_all_os_arch {|os,arch|
        sh "go build -mod=readonly -o #{binary_path(os, arch)} gauge-ruby.go"
    }
end

desc "Create installable packages for all supported OS/Arch"
task :package_all => [:clobber, :xcompile] do
    run_for_all_os_arch {|os, arch| create_package(os, arch)}
end

desc "Create current OS/Arch specific installable packages"
task :package => [:clobber, :compile] do
    create_package
end

desc "Install Gauge-ruby plugin"
task :force_install, [:prefix] => [:package] do |t, args|
    env_vars = (args[:prefix] || "") == "" ? {} : {"GAUGE_HOME" => args[:prefix]}
    system env_vars, "gauge uninstall ruby --version #{PLUGIN_VERSION}"
    system env_vars, "gauge install ruby -f deploy/gauge-ruby-#{PLUGIN_VERSION}.zip"
end

desc "Generate protobuf stubs"
task :gen_proto do
    system "grpc_tools_ruby_protoc -I gauge-proto --ruby_out=lib --grpc_out=lib  gauge-proto/messages.proto gauge-proto/spec.proto gauge-proto/services.proto"
end

def create_package(os=nil, arch=nil)
    dest_dir="gauge-ruby-#{PLUGIN_VERSION}-#{os}.#{ARCH_MAP[arch]}".chomp('.').chomp('-')
    deploy_dir = "deploy/#{dest_dir}"
    bin_dir = "#{deploy_dir}/bin"
    mkdir_p bin_dir
    ["skel", "ruby.json", "notice.md"].each {|f|
        cp_r f, deploy_dir, verbose: true, preserve: true
    }
    cp_r binary_path(os, arch), bin_dir, preserve: true, verbose: true
    if windows?
        zf = ZipFileGenerator.new(deploy_dir, "#{deploy_dir}.zip")
        zf.write()
    else
        Dir.chdir(deploy_dir){
            system "zip -r ../#{dest_dir}.zip ."
        }
    end
    rm_rf deploy_dir
end

def binary_path(os, arch)
    os_subdir="/#{os}_#{ARCH_MAP[arch]}" unless os==nil
    "pkg#{os_subdir}/#{binary_name(os)}"
end

def binary_name(os)
    if os == "windows" || (os==nil && windows?)
        return "gauge-ruby.exe"
    end
    "gauge-ruby"
end

def windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
end

def run_for_all_os_arch
    ["amd64", "arm64"].each {|arch|
        ["darwin", "linux", "windows"].each {|os|
            ENV["GOOS"] = os
            ENV["GOARCH"] = arch
            yield os, arch
        }
    }
end

class ZipFileGenerator
    def initialize(inputDir, outputFile)
        @inputDir = inputDir
        @outputFile = outputFile
    end

    def write()
        entries = Dir.entries(@inputDir); entries.delete("."); entries.delete("..")
        io = Zip::File.open(@outputFile, Zip::File::CREATE);
        writeEntries(entries, "", io)
        io.close();
    end

    private
    def writeEntries(entries, path, io)
        entries.each { |e|
            zipFilePath = path == "" ? e : File.join(path, e)
            diskFilePath = File.join(@inputDir, zipFilePath)
            puts "Deflating " + diskFilePath
            if  File.directory?(diskFilePath)
                io.mkdir(zipFilePath)
                subdir =Dir.entries(diskFilePath); subdir.delete("."); subdir.delete("..")
                writeEntries(subdir, zipFilePath, io)
            else
                io.get_output_stream(zipFilePath) { |f| f.puts(File.open(diskFilePath, "rb").read())}
            end
        }
    end
end
