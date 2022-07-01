intro on custom attributes:
- https://powershellexplained.com/2017-02-19-Powershell-custom-attribute-validator-transform/
- https://powershellexplained.com/2017-02-20-Powershell-creating-parameter-validators-and-transforms/

- https://docs.microsoft.com/en-us/dotnet/standard/attributes/writing-custom-attributes#custom-attribute-example

- docs 
  - [ArgumentTransformationAttribute](https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.argumenttransformationattribute?view=powershellsdk-7.0.0#remarks)
    - Throw ArgumentException if the value of inputData is invalid, and throw ArgumentTransformationMetadataException for other recoverable errors.
  - [vexx32.github.io/Working-Argument-Transformations](https://vexx32.github.io/2018/12/13/Working-Argument-Transformations/)

> Retrieving Multiple Instances of an Attribute Applied to the Same Scope
> 
https://docs.microsoft.com/en-us/dotnet/standard/attributes/retrieving-information-stored-in-attributes#retrieving-multiple-instances-of-an-attribute-applied-to-the-same-scope

cs:
- <https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/generics/generics-and-attributes>

```cs
public class GenericClass2<T, U> { }

[CustomAttribute(info = typeof(GenericClass2<,>))]
class ClassB { }
```