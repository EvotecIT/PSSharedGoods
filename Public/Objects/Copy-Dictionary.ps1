function Copy-Dictionary {
    [alias('Copy-Hashtable','Copy-OrderedHashtable')]
    [cmdletbinding()]
    param(
        [System.Collections.IDictionary] $Dictionary
    )
    # create a deep-clone of an object
    $ms = [System.IO.MemoryStream]::new()
    $bf = [System.Runtime.Serialization.Formatters.Binary.BinaryFormatter]::new()
    $bf.Serialize($ms, $Dictionary)
    $ms.Position = 0
    $clone = $bf.Deserialize($ms)
    $ms.Close()
    $clone
}