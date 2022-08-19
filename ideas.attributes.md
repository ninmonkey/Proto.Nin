Random custom attribute ideas

## See: 


- [New-PesterConfig](https://pester.dev/docs/commands/New-PesterConfiguration)
- [Should -CompletionText](https://github.com/SeeminglyScience/ClassExplorer/blob/master/test/Completion.Tests.ps1)
- [Complete\(\), BeTrueForAll\(\)](https://github.com/SeeminglyScience/ClassExplorer/blob/a5aa12af456f6d10a233428460af0fbfbd0f24aa/test/shared.psm1#L68-L122)

## First Sprint Checklist

- [ ] Switch/FlagNotImplemented # on use
- [ ] tag: not optimized 

## Text

- [ ] [transform] Clean String, arg transformation   
  - clean some or all of strings:
    - basic whitespace: newline, tab, etc
    - the other c0-c1 control sequence
    - unicode non-printable codepoints

## Files
- [ ] existence of filepaths, optional ensure they are created
    - [ ] ResolveFilepath
    - [ ] EnsureFilepath
- [ ] resolve/ensure-Item (folder or file)

## type inspection

- [ ] resolve/ensure-TypeInfo

## Completer

- [ ] resolve->Encoder
- [ ] Complete: NinCommand, FavCommands, etc

## Pester

> Config, see `OutputCOnfiguration.cs`
```cs
//   `$config.Debug = @{ WriteDebugMessages = $true; WriteDebugMessagesFrom = "Mock*" }`, which
//   will populate the config with the given values while keeping all other values to the default.
// - to be able to assign values like this: `$config.Should.ErrorAction = 'Continue'` but still
//   get the documentation when accessing the property, we use implicit casting to get an instance of
//   StringOption, and then populate it from the option object that is already assigned to the property
```