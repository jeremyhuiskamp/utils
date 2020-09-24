use std::io;

use clap::{App, Arg};
use csv::WriterBuilder;

fn main() -> Result<(), csv::Error> {
    let matches = App::new("CSV line escaper")
        .about("formats a single line of csv output")
        .arg(Arg::with_name("delimiter")
            .short("d")
            .long("delimiter")
            .value_name("CHAR")
            .default_value(",")
            .takes_value(true))
        .arg(Arg::with_name("columns")
            .multiple(true))
        .get_matches();

    let columns = matches.values_of("columns")
        .map(|vals| vals.collect::<Vec<_>>());

    let delimiter = {
        let bytes = matches.value_of("delimiter")
            .unwrap()
            .as_bytes();
        // what does this do if the first char is multi-byte?
        // should we reject if there's not exactly one char?
        if bytes.is_empty() { ',' as u8 } else { bytes[0] }
    };

    if let Some(vals) = columns {
        let mut wtr = WriterBuilder::new()
            .delimiter(delimiter)
            .from_writer(io::stdout());
        wtr.write_record(vals)?;
        wtr.flush()?;
    }
    Ok(())
}
