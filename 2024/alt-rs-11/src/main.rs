//use rayon::prelude::*;
use std::time::Instant;
use std::collections::HashMap;
use memoize::memoize;

#[inline]
fn number_length(mut n: i64) -> i64 {
    if n == 0 {
        return 1;
    }
    let mut len = 0;
    while n > 0 {
        n /= 10;
        len += 1;
    }
    len
}

#[inline]
fn split_number(n: i64) -> (i64, i64) {
    let len = number_length(n);
    let half = len / 2;
    let divisor = 10_i64.pow(half as u32);
    let second = n % divisor;
    let first = n / divisor;
    (first, second)
}

#[inline]
#[memoize]
fn blink_one(n: i64) -> Vec<i64> {
    if n == 0 {
        vec![1]
    } else {
        let len = number_length(n);
        if len % 2 == 0 {
            let (first, second) = split_number(n);
            vec![first, second]
        } else {
            vec![n * 2024]
        }
    }
}

fn blink_stones_iterative_map(stones: Vec<i64>, mut times_rem: i64) -> usize {
    let mut fmap: HashMap<i64, usize> = HashMap::new();
    for stone in stones.iter() {
        let last = fmap.get(stone).unwrap_or(&0);
        fmap.insert(*stone, *last + 1);
    }

    while times_rem > 0 {
        let mut new_map: HashMap<i64, usize> = HashMap::new();
        for (key, value) in fmap.drain() {
            let res = blink_one(key);
            let l = res[0];
            new_map.entry(l)
                .and_modify(|val| *val += value )
                .or_insert(value);

            if res.len() > 1 {
                let r = res[1];
                new_map.entry(r)
                    .and_modify(|val| *val += value )
                    .or_insert(value);
            }
        }
        fmap = new_map;
        times_rem -= 1;
    }
    fmap.into_values()
        .fold(0, |acc, v| acc + v)
}

fn main() {
    let puzzle_input = "6563348 67 395 0 6 4425 89567 739318";
    let stones: Vec<i64> = puzzle_input
        .split_whitespace()
        .filter_map(|s| s.parse::<i64>().ok())
        .collect();

    let t0 = Instant::now();
    let result = blink_stones_iterative_map(stones, 75);
    let t1 = Instant::now();

    println!("Result: {}", result);
    println!("Time: {:?}", t1.duration_since(t0));
}

