<#
------------------------------------------------------------------------
# Desenvolvido por: Thiago Fernandes                                      
# Data: 22/10/2024                                                         

# Para que o script funcione, é necessário a instalação da ferramenta
# de Administração de Servidor Remoto        
# https://www.microsoft.com/pt-br/download/details.aspx?id=45520
------------------------------------------------------------------------
#>

# Função para buscar usuário pelo GiveName (Matricula)
function Get-UserByGivenName {
    param(
        [string]$GivenName
    )

    # Realiza a busca no Active Directory usando GivenName
    $users = Get-ADUser -Filter {GivenName -like $GivenName} -Property CN, GivenName, Department, PasswordLastSet, LockedOut, Enabled, LastBadPasswordAttempt, EmailAddress

    if ($users.Count -eq 1) {
        return $users
    } else {
        Write-Host "Nenhum usuario encontrado com o nome: $username"
        return $null
    }
}

# Solicitar o username
$username = Read-Host "Informe o username (deixe em branco se nao souber)"
#$username = 'ThiagoF_Silva'

#Write-Host "---------------------------------------------`nUsuario: $($user.CN)`nMatricula: $($user.GivenName)`nEmail: $($user.EmailAddress)`nDepartamento: $($user.Department)`nAtivo: $($user.Enabled)`nLast PW Reset: $($user.PasswordLastSet)`nLastBadPasswordAttempt: $($user.LastBadPasswordAttempt)`nLockedOut: $($user.LockedOut)`n---------------------------------------------"

# Verifica se o username foi informado
if ([string]::IsNullOrWhiteSpace($username)) {
    # Se o username não foi informado, solicitar a matricula (GivenName)
    $givenName = Read-Host "Informe a matricula"

    # Busca pela matrícula no Active Directory pelo GivenName
    #$user = Get-UserByGivenName -GivenName $givenName
    $user = Get-ADUser -Filter {GivenName -like $givenName} -Property CN, GivenName, Department, PasswordLastSet, LockedOut, Enabled, LastBadPasswordAttempt, EmailAddress

    if ($user -ne $null) {
        Write-Host "---------------------------------------------`nUsuario: $($user.CN)`nMatricula: $($user.GivenName)`nEmail: $($user.EmailAddress)`nDepartamento: $($user.Department)`nAtivo: $($user.Enabled)`nLast PW Reset: $($user.PasswordLastSet)`nLastBadPasswordAttempt: $($user.LastBadPasswordAttempt)`nLockedOut: $($user.LockedOut)`n---------------------------------------------"
    } else {
        Write-Host "Usuario/Matricula nao encontrada"
    }
} else {
    # Se o username foi informado, buscar diretamente no AD
    try {
        $user = Get-ADUser -Identity $username -Property CN, GivenName, Department, PasswordLastSet, LockedOut, Enabled, LastBadPasswordAttempt, EmailAddress
    } catch {
        Write-Output "Usuario nao encontrado"
    }
    

    if ($user -ne $null) {
        Write-Host "---------------------------------------------`nUsuario: $($user.CN)`nMatricula: $($user.GivenName)`nEmail: $($user.EmailAddress)`nDepartamento: $($user.Department)`nAtivo: $($user.Enabled)`nLast PW Reset: $($user.PasswordLastSet)`nLastBadPasswordAttempt: $($user.LastBadPasswordAttempt)`nLockedOut: $($user.LockedOut)`n---------------------------------------------"
    } #else {
#        Write-Host "Usuario nao encontrado."
#    }
}

# Array
#$table = @(
#    @{
#        Usuario = $($user.CN)
#        LockedOut = $($user.LockedOut)
#        Matricula = $($user.GivenName)
#        Departamento = $($user.Department)
#        Enabled = $($user.Enabled)
#        #PW_Set = $($user.PasswordLastSet)
#    }
#)