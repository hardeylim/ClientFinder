# ClientFinder

A minimalist command-line application for searching client and staff data with advanced search capabilities.

## Features

- Search records by name (partial, case-insensitive matching)
- Find duplicate email addresses across records
- Search staff by rating threshold
- Generic JSON data handling for flexible record types
- Multiple data source support (clients.json, staff.json)

## Requirements

- Ruby 2.6 or higher (If not installed, download from [Ruby Official Website](https://www.ruby-lang.org/en/downloads/))

## Quick Start (Users)

1. Clone the repository:
   ```
   git clone https://github.com/hardeylim/ClientFinder
   cd ClientFinder
   ```

2. Make the executable script runnable:
   ```
   chmod +x bin/client_finder
   ```

## Usage

### Search for records by name

```
./bin/client_finder search "John"              # Search in clients.json (default)
./bin/client_finder search "John" staff        # Search in staff.json
```

### Search for records by a specific field

```
./bin/client_finder search "john.doe@gmail.com" --field email
```

### Search for staff by rating

```
./bin/client_finder ratings 3.5 staff          # Find staff with rating >= 3.5
```

### Find duplicate emails

```
./bin/client_finder find-duplicates
```

### Show help

```
./bin/client_finder help
```

## Assumptions

- JSON files can contain any fields, with optional rating field for staff data
- Records can be either client or staff data with common searchable fields
- Generic record handling allows for flexible data structures
- Case-insensitive searching is desired for better user experience
- The application will be run in a Unix-like environment

## Project Structure

- `bin/`: Contains the executable script
- `data/`: Contains JSON data files (clients.json, staff.json)
- `lib/`: Contains the application code
  - `models/`: Data models (Client, Staff)
  - `repository/`: Data access layer with generic JSON handling
  - `services/`: Business logic (Search, Ratings, Duplicate Finding)
  - `cli/`: Command-line interface

## Future Enhancements

The application is designed to be easily extended with:

1. Additional data source support with automatic schema detection
2. Advanced filtering and sorting capabilities
3. Data validation and schema enforcement
4. Record comparison and merging features
5. REST API interface for remote access
6. Scalable design for larger datasets
7. Enhanced analytics and reporting features

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

### Test Coverage

Test coverage reports are generated automatically when running tests. After running the tests, open `coverage/index.html` in your browser to view the coverage report.

The test suite includes:
- Unit tests for models and services
- Integration tests for the command-line interface
- Test coverage for edge cases and error handling
- Validation of generic data handling

## Contributing

1. Ensure all tests pass and maintain or improve test coverage
2. Follow the existing code style and patterns
3. Add tests for any new functionality
4. Update documentation as needed

## License

[MIT License](LICENSE)
