use std::io::Read;
use std::{env, io};

use htmlescape::{decode_html_rw, encode_minimal_w, DecodeErr};

fn help(prog_name: &String) {
    println!("usage: {} [-e]", prog_name);
    std::process::exit(1);
}

// TODO: deduplicate
#[derive(Debug)]
enum EscapeError {
    IoError(io::Error),
    DecodeErr(DecodeErr),
}

impl From<io::Error> for EscapeError {
    fn from(e: io::Error) -> EscapeError {
        EscapeError::IoError(e)
    }
}

impl From<DecodeErr> for EscapeError {
    fn from(e: DecodeErr) -> EscapeError {
        EscapeError::DecodeErr(e)
    }
}

fn main() -> Result<(), EscapeError> {
    let args: Vec<String> = env::args().collect();
    let prog_name = &args[0];
    let mut escape = false;
    for arg in env::args().skip(1) {
        match &arg[..] {
            "-e" => {
                escape = true;
            }
            _ => {
                help(prog_name);
            }
        }
    }
    if escape {
        // TODO: streaming
        let mut buffer = String::new();
        io::stdin().lock().read_to_string(&mut buffer)?;
        encode_minimal_w(buffer.as_ref(), &mut io::stdout().lock())?;
    } else {
        decode_html_rw(io::stdin().lock(), &mut io::stdout().lock())?;
    }
    Ok(())
}
