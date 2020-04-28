:: Copyright (c) ThoughtWorks, Inc.
:: Licensed under the Apache License, Version 2.0
:: See LICENSE.txt in the project root for license information.

:: using gem ruby-protocol-buffers
cd gauge-proto
ruby-protoc -o ..\lib spec.proto && ruby-protoc -o ..\lib messages.proto && ruby-protoc -o ..\lib api.proto && cd ..
