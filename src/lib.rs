use pgrx::prelude::*;

pgrx::pg_module_magic!();


// Company module
#[pg_extern]
fn company() -> String {
    use faker_rand::en_us::company::CompanyName;
    rand::random::<CompanyName>().to_string()
}

#[pg_extern]
fn slogan() -> String {
    use faker_rand::en_us::company::Slogan;
    rand::random::<Slogan>().to_string()
}


// People module
#[pg_extern]
fn person_first_name() -> String {
    use faker_rand::en_us::names::FirstName;
    rand::random::<FirstName>().to_string()
}

#[pg_extern]
fn person_last_name() -> String {
    use faker_rand::en_us::names::LastName;
    rand::random::<LastName>().to_string()
}

#[pg_extern]
fn person_full_name() -> String {
    use faker_rand::en_us::names::FullName;
    rand::random::<FullName>().to_string()
}

#[pg_extern]
fn person_prefix() -> String {
    use faker_rand::en_us::names::NamePrefix;
    rand::random::<NamePrefix>().to_string()
}

#[pg_extern]
fn person_suffix() -> String {
    use faker_rand::en_us::names::NameSuffix;
    rand::random::<NameSuffix>().to_string()
}

// Phones module
#[pg_extern]
fn phone() -> String {
    use faker_rand::en_us::phones::PhoneNumber;
    rand::random::<PhoneNumber>().to_string()
}


// Internet module
#[pg_extern]
fn domain() -> String {
    use faker_rand::en_us::internet::Domain;
    rand::random::<Domain>().to_string()
}

#[pg_extern]
fn email() -> String {
    use faker_rand::en_us::internet::Email;
    rand::random::<Email>().to_string()
}

#[pg_extern]
fn username() -> String {
    use faker_rand::en_us::internet::Username;
    rand::random::<Username>().to_string()
}




#[cfg(any(test, feature = "pg_test"))]
#[pg_schema]
mod tests {
    use pgrx::prelude::*;

    #[pg_test]
    fn test_hello_pgfaker() {
        assert_eq!("Hello, pgfaker", crate::hello_pgfaker());
    }

}

/// This module is required by `cargo pgrx test` invocations.
/// It must be visible at the root of your extension crate.
#[cfg(test)]
pub mod pg_test {
    pub fn setup(_options: Vec<&str>) {
        // perform one-off initialization when the pg_test framework starts
    }

    pub fn postgresql_conf_options() -> Vec<&'static str> {
        // return any postgresql.conf settings that are required for your tests
        vec![]
    }
}
