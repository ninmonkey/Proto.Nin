  @{

   [system.text.encoding]::ASCII.getbytes($sampleStr).count
   [system.text.encoding]::UTF8.getbytes($sampleStr).count
   [system.text.encoding]::unicode.getbytes($sampleStr).count

}
