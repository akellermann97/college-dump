// Author: Alexander Kellermann Nieves
//
//

use std::io;

extern crate rand; // Rust does not have a random number generator as
// part of its standard library yet.

fn modulo(base: i64, mut exponent: i64, modulo: i64) -> i64 {
    let mut x: i64 = 1;
    let mut y: i64 = base;
    while exponent > 0 {
        if exponent % 2 == 1 {
            x = (x * y) % modulo;
        }
        y = (y * y) % modulo;
        exponent = exponent / 2;
    }
    return x % modulo;
}

fn fermat(p: i64, iterations: i64) -> i64 {
    if p == 1 {
        return 0;
    }
    for thing in 0..iterations {
        let mut a: i64 = rand::random::<i64>() % (p - 1) + 1;
            if modulo(a, p - 1, p) != 1 {
                return 0
            }

    }
    return 1;
}

fn main(){
    let iteration = 50;
    let mut num = String::new();
    println!("Enter Integer to test if it's prime");

    io::stdin().read_line(&mut num)
        .expect("Couldn't read line");

    let num_converted: i64 = num.trim().parse().unwrap();

    if fermat(num_converted, iteration) == 1 {
        println!("Number is prime");
    } else {
        println!("Number is not prime");
    }

}
