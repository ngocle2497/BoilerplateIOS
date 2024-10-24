## Welcome to the Boilerplate IOS

:fireworks: Clean and minimalist IOS template for a quick start with **Clean Arch** and so much more components.

## :star: Features

- Elegant usage directly within the RN-Boiler Cli
- Minimal additional dependencies
- Multiple schema ios(Dev/Prod as default)

## Base config (Now u can config on env)

- Change App name `APP_DISPLAY_NAME` on `Configuration/(Dev.xcconfig/Prod.xcconfig)`
- Change App id `BUNDLE_IDENTIFIER` on `Configuration/(Dev.xcconfig/Prod.xcconfig)`
- Change App version `VERSION_NAME` on `Configuration/(Dev.xcconfig/Prod.xcconfig)`
- Change App build number `VERSION_CODE` on `Configuration/(Dev.xcconfig/Prod.xcconfig)`

## :arrow_forward: Usage

### Requirement

#### Install node

```sh
brew instal node
```

#### Create Template

```sh
npx rn-boiler MyApp -t ios
```

Args command:

```
Usage: rn-boiler <project-name> -t ios [options]

Arguments:
  project-name                     Project name

Options:
  -v, --version                    Output the current version
  --skip-install                   Skip install dependencies. Default: false.
                                   (default: false)
  --skip-git                       Skip git init. Default: false. (default:
                                   false)
  --verbose                        Default: false. (default: false)
  -h, --help                       display help for command
```
