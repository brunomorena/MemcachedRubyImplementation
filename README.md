# Memcached server implementation on Ruby

## Prerequisites

This project was developed on Windows 10 environment. Before running the server it is necesary to have a Ruby version installed and the Telnet Client enabled.
To run the unit tests it is necessary to have installed the RSpec gem.

## Installation

* Ruby

Get and install [Ruby](https://www.ruby-lang.org/es/downloads/)

The Ruby version used is 2.7.4

* Telnet Client

Install Telnet on Windows
Telnet is not installed by default on Windows; if you try to run it you will get the message "'Telnet' is not recognized as an operable program or batch file." To install Telnet:

1. Click Start.
2. Select Control Panel.
3. Choose Programs and Features.
4. Click Turn Windows features on or off.
5. Select the Telnet Client option.
6. Click OK.

A dialog box appears to confirm installation. The telnet command should now be available.

* RSpec gem

Run cmd.exe, simply click on the Start menu and type "cmd.exe", then hit the Return key, then type the following

``` rb
gem install rspec
```

## Usage

To run the server, open a cmd on the folder of the project and type the following:

``` rb
ruby server.rb 
```

Now to connect to the server, open the Telnet Client on cmd and type:

``` rb
telnet localhost 11211
```

Once the connection has been established you can type commands.

To run the tests open a cmd on the folder of the project and type:

``` rb
rspec
```

This command will run all the tests at the defined order (alphanumeric) and these are not independent.

## Command syntax

* Storage commands:

``` rb
<command_name> <key> <flags> <exptime> <bytes>
```

< command_name > is "set", "add", "replace", "append" or "prepend"

``` rb
cas <key> <flags> <exptime> <bytes> <cas_unique>
```

* Retrieval commands:

``` rb
get <key>
```

``` rb
gets <key>*
```

< key >* means one or more key strings separated by whitespace.

* Purge expired keys:

``` rb
purge
```

The file called `sample_commands.txt` contains some examples.

## Extras

These extra features have been made

* [x] Purge expired keys
* [x] Manage multiple clients
* [x] Architectural diagram

## References

[Protocol specification](https://github.com/memcached/memcached/blob/master/doc/protocol.txt)

[Memcached Cheat Sheet](https://lzone.de/cheat-sheet/memcached)

[Memcached](https://www.tutorialspoint.com/memcached/index.htm)

[Socket](https://www.tutorialspoint.com/ruby/ruby_socket_programming.htm)

[RSpec](https://www.tutorialspoint.com/rspec/index.htm)
