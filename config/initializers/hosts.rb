# Allow hosts for proxied access
if Rails.env.test?
  # Disable host authorization for tests
  Rails.application.config.hosts.clear
else
  Rails.application.config.hosts << "www.unix.com"
  Rails.application.config.hosts << "unix.com"
end
