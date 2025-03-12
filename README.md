# ClientFinder

A minimalist command-line application for searching client data and finding duplicates.

## Features

- Search clients by name (partial, case-insensitive matching)
- Find clients with duplicate email addresses
- Extensible architecture for future enhancements

## Requirements

- Ruby 2.6 or higher (If not installed, download from [Ruby Official Website](https://www.ruby-lang.org/en/downloads/))

## Quick Start (Users)

1. Clone the repository:
   ```
   git clone [repository-url]
   cd ClientFinder
   ```

2. Make the executable script runnable:
   ```
   chmod +x bin/client_finder
   ```

## Usage

### Search for clients by name

```
./bin/client_finder search "John"
```

### Search for clients by a specific field

```
./bin/client_finder search "john.doe@gmail.com" --field email
```

### Find clients with duplicate emails

```
./bin/client_finder find-duplicates
```

### Show help

```
./bin/client_finder help
```

## Assumptions

- The JSON file structure follows the format provided in the challenge
- The client data contains at minimum the fields: id, full_name, and email
- Case-insensitive searching is desired for better user experience
- The application will be run in a Unix-like environment

## Project Structure

- `bin/`: Contains the executable script
- `data/`: Contains the client data JSON file
- `lib/`: Contains the application code
  - `models/`: Data models
  - `repository/`: Data access layer
  - `services/`: Business logic
  - `cli/`: Command-line interface

## Future Enhancements

The application is designed to be easily extended with:

1. Support for any JSON file with dynamic field specification
2. REST API interface for the same functionality
3. Scalable design for larger datasets
4. Additional search and analytics capabilities

## Development

This section is for developers who want to contribute or modify the application. Users can skip this section if they only want to use the application.

### Setting up the Development Environment

1. Install development dependencies:
   ```bash
   bundle install   # Only needed for running tests and development
   ```

   Note: This step is not required for regular usage of the application. It installs gems needed for:
   - Running tests (RSpec)
   - Code analysis (RuboCop)
   - Test coverage reporting (SimpleCov)

### Running Tests

The project uses RSpec for testing and SimpleCov for test coverage reporting.

Run all tests:
```bash
bundle exec rspec
```

Run specific test file:
```bash
bundle exec rspec spec/path/to/file_spec.rb
```

Run tests with focus tag:
```bash
bundle exec rspec --tag focus
```

### Test Coverage

Test coverage reports are generated automatically when running tests. After running the tests, open `coverage/index.html` in your browser to view the coverage report.

The test suite includes:
- Unit tests for all models and services
- Integration tests for the command-line interface
- Test coverage for edge cases and error handling

## Contributing

1. Ensure all tests pass and maintain or improve test coverage
2. Follow the existing code style and patterns
3. Add tests for any new functionality
4. Update documentation as needed

## License

[MIT License](LICENSE)
