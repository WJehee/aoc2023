fn main() {
    let input = std::fs::read_to_string("input.txt").unwrap();
    let result: u32 = input
        .split('\n')
        .map(|line| process_line(line))
        .sum();
    println!("{result}");
}

fn process_line(line: &str) -> u32 {
    let mut previous_chars = "     ".to_string();

    let res = line
        .chars()
        .filter_map(|x| match x {
            i if x.is_numeric() => i.to_digit(10),
            c if x.is_alphabetic() => {
                previous_chars.push(c);
                match &previous_chars[previous_chars.len()-5..] {
                    x if x == "three" => Some(3),
                    x if x == "seven" => Some(7),
                    x if x == "eight" => Some(8),
                    x => match &x[1..] {
                        x if x == "four" => Some(4),
                        x if x == "five" => Some(5),
                        x if x == "nine" => Some(9),
                        x => match &x[1..] {
                            x if x == "one" => Some(1),
                            x if x == "two" => Some(2),
                            x if x == "six" => Some(6),
                            _ => None
                        }
                    }
                }
            },
            _ => panic!("Unexpected character"),
        })
        .collect::<Vec<_>>();
    let digit1 = res.get(0).unwrap_or(&0);
    let digit2 = res.last().unwrap_or(&0);
    
    (10 * digit1) + digit2
}

