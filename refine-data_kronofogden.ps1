# Inputs the Kronofogden project CSV file and removes whitespaces from the number fields
# this is to avoid truncation when importing the values to the database
$filename = Read-Host "Enter CSV file-name for the Kronofogden data project"
$ext = [IO.Path]::GetExtension($filename)
if ($ext -ne ".csv") {$filename = $filename + ".csv"} # Add file ending if not present
if (Test-Path -Path ((Get-Location).ToString() + "/" + $filename)){
  try {
    $csvfile = Import-Csv -Path ./$filename -Delimiter ';' -Encoding Default
  }
  catch {
    throw "Importing $filename failed"
  }
  foreach ($row in $csvfile) {
    $row."Utropspris (kr)" = $row."Utropspris (kr)" -replace '\s', ''
    $row."Startpris (kr)" = $row."Startpris (kr)" -replace '\s', ''
    $row."Betalat belopp (kr)" = $row."Betalat belopp (kr)" -replace '\s', ''
    $row."Vill ha frakt" = $row."Vill ha frakt" -replace "Nej", 0
    $row."Vill ha frakt" = $row."Vill ha frakt" -replace "Ja", 1
  }
  try {
    $csvfile | Export-Csv -Path ./clean.csv -NoTypeInformation -Encoding Default -UseCulture
  }
  catch {
    throw "Exporting to file Clean.csv failed. Make sure it's not opened somewhere!"
  }
  Write-Host "Success!"
}
else {
  Write-Host "Could not verify file name $filename"
}

