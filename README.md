# PgFaker

Postgres extension to provide fake data for test databases, performance testing,
and other demo purposes.

The `pgfaker` extension is built using the Rust
[pgrx framework](https://github.com/tcdi/pgrx).


## Getting started

```sql
CREATE EXTENSION pgfaker;
```



```sql
SELECT pgfaker.company(), pgfaker.person_first_name(), pgfaker.person_last_name(),
        pgfaker.person_prefix(), pgfaker.person_suffix(), pgfaker.email(),
        pgfaker.phone(),
        pgfaker.slogan(), pgfaker.username(), pgfaker.domain()
;
```

```bash
┌─[ RECORD 1 ]──────┬─────────────────────────────┐
│ company           │ Jacobson-Wyman              │
│ person_first_name │ Adell                       │
│ person_last_name  │ Treutel                     │
│ person_prefix     │ Mr.                         │
│ person_suffix     │ Jr.                         │
│ email             │ mwhite6@glover.net          │
│ phone             │ (907) 125-0407              │
│ slogan            │ Configurable scalable users │
│ username          │ dwalker                     │
│ domain            │ weissnat.name               │
└───────────────────┴─────────────────────────────┘
```



## Creating installer for your system

Currently no pre-packaged installers are available. The following steps walk through
creating a package on a typical Ubuntu based system with Postgres 14.
These steps assume cargo pgrx is already installed.


The `fpm` step requires the `fpm` Ruby gem.

```bash
sudo apt install ruby-rubygems
sudo gem i fpm
```

> Timing note:  `cargo pgrx package` takes ~ 2 minutes on my main dev machine.


```bash
cargo pgrx package --pg-config /usr/lib/postgresql/15/bin/pg_config
cd target/release/pgfaker-pg15/

find ./ -name "*.so" -exec strip {} \;
OUTFILE=pgfaker.deb
rm ${OUTFILE} || true
fpm \
  -s dir \
  -t deb -n pgfaker \
  -v 0.0.1 \
  --deb-no-default-config-files \
  -p ${OUTFILE} \
  -a amd64 \
  .

sudo dpkg -i --force-overwrite ./pgfaker.deb
```


