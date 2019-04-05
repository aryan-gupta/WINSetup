
#include <boost/asio.hpp>

#include "Connection.hpp"
#include "Server.hpp"

namespace ip = boost::asio::ip;
namespace asio = boost::asio;

Connection::Connection(Server* svr)
	: socket{ svr->get_context(), ip::tcp::endpoint{ ip::tcp::v4(), svr->get_port() } }
	, buffer{ }
	{  }