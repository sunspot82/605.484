# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_project3_session',
  :secret      => '6983b84be137becdbdbab7b85dcf26e12e5610c7bbebf0fc22ce93c6655d869cb0dfa690673b73dd1f5a7d2824c9721e43cc85ac18bfe4acbf232ae0cb32daa7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
