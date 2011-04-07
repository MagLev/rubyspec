require 'socket'

module SocketSpecs
  # helper to get the hostname associated to 127.0.0.1
  def self.hostname
    # Calculate each time, without caching, since the result might
    # depend on things like do_not_reverse_lookup mode, which is
    # changing from test to test
    Socket.getaddrinfo("127.0.0.1", nil)[0][2]
  end

  def self.hostnamev6
    Socket.getaddrinfo("::1", nil)[0][2]
  end
  
  def self.port
    p = 40001
    deviates_on :maglev do
      p = 10202  # For solaris, a port in services database
    end
    p 
  end
  
  def self.str_port
    s = "40001"
    deviates_on :maglev do
      s = "10202" # For solaris, a port in services database
    end
    s
  end

  def self.sockaddr_in(port, host)
    Socket::SockAddr_In.new(Socket.sockaddr_in(port, host))
  end

  def self.socket_path
    tmp("unix_server_spec.socket", false)
  end
end
