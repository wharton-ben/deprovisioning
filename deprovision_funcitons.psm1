function Remove-DocumentsFolder {
    [CmdletBinding()]
    param (
        $username
    )
    
    if(test-path \\leto\Shared\users\$username){
        
        if (test-path \\leto\shared\Scan\$username){
            copy-item \\leto\shared\Scan\$username \\leto\shared\users\$username
            remove-item \\leto\shared\scan\$username -Recurse -force -Confirm:$false
        }
        
        7z a \\truenas\archives\UserDocumentsArchive\$username.zip \\leto\shared\users\$username
        Remove-Item \\leto\shared\users\$username -recurse -force -Confirm:$false
    }
}

<#
This function will generate a random string of characters to use for a disabled user's password. 
#>

function generate-password {
    -join ((33..126) | Get-Random -Count 16 | % {[char]$_})
}

<#
This function will reset the user's password to something random, remove all of their
group memberships and then move them to the former employees OU.
#>

function Remove-User {
    [CmdletBinding()]
    param (
        $username
    )
    $termedUser = Get-ADUser -Identity $username -Properties *
    $password = generate-password
    Set-ADUser -Identity $username `
        -CannotChangePassword $true `
        -PasswordNeverExpires $true
    Move-ADObject -Identity $termedUser.DistinguishedName -TargetPath "OU=Former Employees,OU=DRI,DC=Dridesign,DC=com"
    Set-ADAccountPassword -Identity $username `
        -Reset `
        -NewPassword (ConvertTo-SecureString -AsPlainText $password -force)
    # Remove all group memberships except domain users
    try {
        $groups = Get-ADPrincipalGroupMembership -Identity $username | Where-Object {$_.name -notlike "Domain Users"}
        Remove-ADPrincipalGroupMembership -Identity $username -MemberOf $groups
    }
    catch {
        {This user is not a member of any groups.}
    }
    
}

function deprovision-user{
    [CmdletBinding()]
    param ( 
        $username
    )
    write-host "Removing user..."
    try {
        Remove-user $username
    }
    catch {
        Write-host "Could not remove user."
    }
    write-host "Archiving My Documents and Scan Folder..."
    start-sleep -Milliseconds 20
    try {
        Remove-DocumentsFolder $username
    }
    catch {
        Write-host "Could not archive folders. Either the folders do not exist or the username was entered incorrectly." -ForegroundColor red
    } 
}