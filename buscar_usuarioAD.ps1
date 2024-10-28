<#
------------------------------------------------------------------------
# Desenvolvido por: Thiago Fernandes                                      
# Data: 22/10/2024   
# v01:  28/10/2024 Incluso o loop para verificar username, givenname

# Para que o script funcione, é necessário a instalação da ferramenta
# de Administração de Servidor Remoto        
# https://www.microsoft.com/pt-br/download/details.aspx?id=45520
------------------------------------------------------------------------
#>

function Get-UserByUserName {
    param(
        [string]$UserName
    )
    try {
        $user = Get-ADUser -Identity $UserName -Property CN, GivenName, Department, PasswordLastSet, LockedOut, Enabled, LastBadPasswordAttempt, EmailAddress
    } catch {
        Write-Host "Usuario nao encontrado"
        $user = $null
    }
    return $user
}

# Função para buscar usuário pelo GiveName (Matricula)
function Get-UserByGivenName {
    param(
        [string]$GivenName
    )

    # Realiza a busca no Active Directory usando GivenName
    $user = Get-ADUser -Filter {GivenName -like $GivenName} -Property CN, GivenName, Department, PasswordLastSet, LockedOut, Enabled, LastBadPasswordAttempt, EmailAddress
    return $user
}

do {
    $username = Read-Host "Informe o username (deixe em branco se nao souber)"
    if(![string]::IsNullOrWhiteSpace($username)) {
        # Tenta buscar o usuário pelo username
        $user = Get-UserByUserName -UserName $username
    }
} while (![string]::IsNullOrWhiteSpace($username) -and $user -eq $null)

# Verifica se um usuário foi encontrado ou se o campo foi deixado em branco
if ($user -ne $null) {
    # Exibe informações do usuário encontrado
    Write-Host "---------------------------------------------`nUsuario: $($user.CN)`nMatricula: $($user.GivenName)`nEmail: $($user.EmailAddress)`nDepartamento: $($user.Department)`nAtivo: $($user.Enabled)`nLast PW Reset: $($user.PasswordLastSet)`nLastBadPasswordAttempt: $($user.LastBadPasswordAttempt)`nLockedOut: $($user.LockedOut)`n---------------------------------------------"
} else {
    # Se o username foi deixado em branco, solicita a matrícula
    $givenName = Read-Host "Informe a matricula"
    $user = Get-UserByGivenName -GivenName $givenName

    if ($user -ne $null) {
        Write-Host "---------------------------------------------`nUsuario: $($user.CN)`nMatricula: $($user.GivenName)`nEmail: $($user.EmailAddress)`nDepartamento: $($user.Department)`nAtivo: $($user.Enabled)`nLast PW Reset: $($user.PasswordLastSet)`nLastBadPasswordAttempt: $($user.LastBadPasswordAttempt)`nLockedOut: $($user.LockedOut)`n---------------------------------------------"
    } else {
        Write-Host "Usuario/Matricula nao encontrada"
    }
}