
**FinnUI** held some of the UI used to build the FINN.no iOS app but this repository is no longer used and maintained.

---------------------------

Run the Demo project for a list of all our components.

The main purpose of this library is for internal use and to be used as reference for other teams in how we do things inside **FINN.no**.

## Development
Open the `Workspace/FinnUIDemo.xcworkspace` file to do development, that will enable you to edit the code in the package, edit the code in the demo, and run the Demo project (the reason for not having the workspace file in root is because then Xcode will select the Package.swift for it's list of recents despite that you used the workspace before).

## Installation
### CocoaPods

```
pod "FinnUI", git: "https://github.com/finn-no/finnui-ios"
```

You will also need to include the FinniversKit dependency in your Podfile.
```
pod "FinniversKit", git: "https://github.com/finn-no/FinniversKit"
```

## Usage

Import the framework to access all the components.

```swift
import FinnUI
```

## Create new releases

### Setup
- Install dependencies with `bundle install` (dependencies will be installed in `./bundler`)
- Fastlane will use the GitHub API, so make sure to create a personal access token [here](https://github.com/settings/tokens) and place it within an environment variable called **`FINN_GITHUB_COM_ACCESS_TOKEN`**.
  - When creating a token, you only need to give access to the scope `repo`.
  - There are multiple ways to make an evironment variable, for example by using a `.env` file or adding it to `.bashrc`/`.bash_profile`). Don't forget to run `source .env` (for whichever file you set the environment variables in) if you don't want to restart your shell.
  - Run `bundle exec fastlane verify_environment_variable` to see if it is configured correctly.
- Run `bundle exec fastlane verify_ssh_to_github` to see if ssh to GitHub is working.

### Make release
- Run `bundle exec fastlane` and choose appropriate lane. Follow instructions, you will be asked for confirmation before all remote changes.
- After the release has been created you can edit the description on GitHub by using the printed link.


## Interesting things

### Changelogs

This project has a `Gemfile` that specify some development dependencies, one of those is `pr_changelog` which is a tool that helps you to generate changelogs from the Git history of the repo. You install this by running `bundle install`.

To get the changes that have not been released yet just run:

```
$ pr_changelog
```

If you want to see what changes were released in the last version, run:

```
$ pr_changelog --last-release
```

You can always run the command with the `--help` flag when needed.

### Accessibility

Everything we do we aim it to be accessible, our two main areas of focus have been VoiceOver and Dynamic Type.

### Snapshot Testing

When making UI changes it's quite common that we would request an screenshot of the before and after, adding Snapshot testing made this trivial, if there was UI changes you would get a failure when building through the CI.

**FinnUI** uses [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) to compare the contents of a UIView against a reference image.

When you run the tests **FinnUI** will take snapshot of all the components and will look for differences. If a difference is caught you'll be informed in the form of a failed test. Running the tests locally will generate a diff between the old and the new images so you can see what caused the test to fail.

#### Testing a new component

To test a new component go to [UnitTests](UnitTests) and add a new `func` with the name of your component under the section that makes sense, for example if your component is a _Fullscreen_ component and it's called _RegisterView_ then you'll need to add a method to [FullscreenViewTests.swift](UnitTests/FullscreenViewTests.swift) your method should look like this:

```swift
func testRegisterView() {
    snapshot(.registerView)
}
```

Note that the `snapshot` method is a helper method that will call `SnapshotTesting` under the hood.

#### Snapshot failures on Circle CI

There can be instances where the snapshot test pass on your machine but don't on circle ci, when that happens, circle CI will fail and inform the presence of the test results in a `.xctestresult` file. To debug this, re-run the workflow with ssh access, then you will get a command to connect through ssh to circle ci, like:

```sh
ssh -p [port] [IP]
```

Then you can navigate to the path where the test results are located:

```sh
cd Library/Developer/Xcode/DerivedData/[project]/Logs/Test
```

The `.xcresult` is quite large, and it takes a long time to transfer each file, so compress it before downloading:

```sh
tar -cvzf test.tar.gz [.xcresult file]
```

Figure out where you are on the file system so it's easier to `scp` the file to your computer:

```sh
pwd # Copy this value
```

Then navigate to somewhere on your machine, copy this command and fill in the blanks which you should already have:
```sh
scp -v -r -P [port] distiller@[IP]:"[path you copied]/test.tar.gz" .
```

##### All commands
```sh
# SSH to the machine.
ssh -p [port] [IP]

# Navigate to the folder containing the test results.
cd Library/Developer/Xcode/DerivedData/[project]/Logs/Test

# Compress the .xcresult-folder.
tar -cvzf test.tar.gz [*.xcresult]

# Figure out the absolute path you're at on the machine. Copy this value.
pwd

# Disconnect from the machine and copy the compressed file.
scp -v -r -P [port] distiller@[IP]:"[path you copied]/test.tar.gz" .
```

#### Verifying changes for an existing component

If you make changes to any components you'll have to run the test for that component after changing `recordMode` to `true`. Doing this will generate a new reference image that will be used later to verify for changes that affect your component. After you've generated the reference image change `recordMode` back to `false`.
