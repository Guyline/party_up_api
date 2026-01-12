# Load the Rails environment
skip_flags = [
  "--help",
  "-h",
  "-T",
  "-v",
  "help",
  "list",
  "version"
]
require_relative "config/environment" unless skip_flags.include?(ARGV.first)

# Ensure tasks exist with non-zero status if something goes wrong
class << Thor
  def exit_on_failure?
    true
  end
end
