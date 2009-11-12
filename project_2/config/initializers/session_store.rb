# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_project2_session',
  :secret      => 'a397d14a7555320cb388a0c81254c8da5fb50c2e9bd9652ae1e072c16d5449d29409462505adb5a1ffbb324b7eb259d75ef0c87af83a59da999e6995843f56ea'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
