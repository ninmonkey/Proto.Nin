class MyClass {
    IEnumerable FilterItems(IEnumerable inValues) {
        foreach (var el in inValues) {
            if (someLogic(el)) {
                yield return el
            }
        }
    }
}

# MyClass[] myObjects is defined and has values

IEnumerable myValues = GetEnumerable();
foreach (MyClass v in myObjects) {
    myValues = v.FilterItems(myValues);
}
