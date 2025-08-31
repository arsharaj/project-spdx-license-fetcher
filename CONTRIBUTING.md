## Contributing Guidelines

Thank you for considering contributing to this project !
To ensure a smooth and collaborative process, please follow these guidelines.

### How to Contribute

1. **Fork the repository** : Create a copy of this repository on your github account.

2. **Clone your fork** : Clone your forked repository to your local machine.

   ``` bash
   git clone git@github.com:[username]/project-spdx-license-fetcher.git
   ```

3. **Create a branch** : Create a new branch for your work.

   ``` bash
   git checkout -b feature/[your-name]/[feature-name]
   ```

4. **Make your changes** : Implement your changes or feature. Make sure your code follows the project's code style and guidelines.

5. **Test your changes** : Ensure that your changes work as expected by running the appropriate tests.

6. **Commit your changes** : Write clear, concise and meaningful commit messages.

   | Type      | Description                                                          |
   |-----------|----------------------------------------------------------------------|
   | `build`   | Changes that affect the build system or external dependencies        |
   | `ci`      | Changes to our CI configuration files and scripts                    |
   | `docs`    | Documentation-only changes                                           |
   | `feat`    | A new feature                                                        |
   | `fix`     | A bug fix                                                            |
   | `perf`    | A code change that improves performance                              |
   | `refactor`| A code change that neither fixes a bug nor adds a feature            |
   | `style`   | Changes that do not affect the meaning of the code (formatting, etc.)|
   | `test`    | Adding missing tests or correcting existing ones                     |

   ``` bash
   git commit -m "type : add a clear and concise description of your change"
   ```

7. **Push to your fork** : Push your changes to your forked repository.

   ``` bash
   git push origin feature/[your-name]/[feature-name]
   ```

8. **Submit a pull request** : Open a pull request from your branch to the `main` branch of the original repository. In the description, link any related issues and explain your changes in detail. Submit the pull request message in this format : `merge : feature/[your-name]/[feature-name] into main`

### Code of Conduct

By participating in this project, you agree to follow our [Code of Conduct](CODE_OF_CONDUCT.md).

### Guidelines for Contributions

- **Follow coding standards** : Ensure your code follows the project's standards and guidelines.
- **Comment your code** : Write comments, especially for complex logic.
- **Write tests** : If you are adding new features, add tests to cover your code.
- **Keep changes focused** : Submit seperate pull requests for unrelated changes or features.
- **Be respectful in discussions** : We welcome constructive feedback and respectful collaboration.

### Reporting Bugs

If you find a bug, please open an issue using the [Bug Report Template](.github/ISSUE_TEMPLATE/bug_report.md). Include as much detail as possible to help us diagnose and fix the issue quickly.

### Requesting Features

If you have a new feature idea, please submit an issue using the [Feature Request Template](.github/ISSUE_TEMPLATE/feature_request.md). Provide details about the feature and its use case.

### Thank You

Your contributions are greatly appreciated !
Together, we can make this project even better.