// Author: Alexander Kellermann Nieves
// Date: September 25th, 2018

// External dependencies
extern crate getopts;

// Standard stuff
use getopts::Options;
use std::env;
use std::io::{self, Write};
use std::net::{IpAddr, TcpStream};
use std::str::FromStr;

fn main() {
    const HELP_STRING: &'static str = "
    Usage: scan [arguments] [ip address]
    
    Arguments
    --default : scan ports 1 - 1024
    -p : port range to scan. (e.g. 80-8080)
    ";

    let args: Vec<String> = env::args().collect();
    let program = args[0].clone();

    let mut defined_ports: String = String::new();

    let mut opts = Options::new();
    opts.optopt("p", "ports", "Ports to scan", "port range");
    opts.optflag("h", "help", "Print this help");

    let matches = match opts.parse(&args[1..]) {
        Ok(m) => m,
        Err(f) => panic!(f.to_string()),
    };

    if matches.opt_present("h") {
        println!("{}", HELP_STRING)
    }

    if matches.opt_present("p") {}

    //for argument in args {
    //    println!("{}", argument);
    //}
    scan(0, 8000, String::from("127.0.0.1"))
}

fn scan(port_start: u16, port_end: u16, addr: String) {
    let thing = IpAddr::from_str(&addr).unwrap();
    let mut port = port_start;
    loop {
        match TcpStream::connect((thing, port)) {
            Ok(_) => {
                println!("Open Port @ {}", port);
                io::stdout().flush().unwrap();
            }
            Err(_) => {}
        }

        if port > port_end {
            break;
        }

        port += 1;
    }
}
