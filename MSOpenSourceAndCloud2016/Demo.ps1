Select-AzureRmSubscription -SubscriptionName 'Visual Studio Premium med MSDN'
$resourceGroupname = 'opensourcecloudevening2016';
$storageAccountName = "hsfmydemostorageaccount";
$storageAccountName2 = "hsfmydemostorageaccount2";
$rg = New-AzureRmResourceGroup -Name $resourceGroupname -Location 'West Europe';
$sa = New-AzureRmStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroupname -SkuName Standard_LRS -Location 'West europe' -Kind Storage ;
$sa2 = New-AzureRmStorageAccount -Name $storageAccountName2 -ResourceGroupName $resourceGroupname -SkuName Standard_LRS -Location 'West europe' -Kind Storage ;


# Login with second user 
Get-AzureRMResourceGroup
# Back to master user
Get-AzureRmRoleDefinition 
Get-AzureRmRoleAssignment -ResourceGroupName $resourceGroupname;

$role=New-AzureRmRoleAssignment -SignInName 'haralddev@blabla.onmicrosoft.com' -Scope $rg.ResourceId -RoleDefinitionName 'reader'


# Back to Other user
# Show resource group

# Back to master user
# Remove roles 
$role|Remove-AzureRmRoleAssignment ;
$role=New-AzureRmRoleAssignment -SignInName 'haralddev@blabla.onmicrosoft.com' -Scope $rg.ResourceId -RoleDefinitionName 'contributor'

# Create a lock
New-AzureRmResourceLock -LockName 'DoNotDeleteStorageAccount' -LockLevel CanNotDelete -Scope $sa.Id;

# Check that contributor is unable to delete this storage account (other account)


# Create a readonly lock (master account)

New-AzureRmResourceLock -LockName Readonly -Scope $rg.ResourceId -LockLevel ReadOnly;

# See that you're unable to create resources in this RG now
$sa2 = New-AzureRmStorageAccount -Name $storageAccountName2 -ResourceGroupName $resourceGroupname -SkuName Standard_LRS -Location 'West europe' -Kind Storage ;
# fails

# Clean up
Remove-AzureRmResourceLock -LockName readonly -Scope $rg.ResourceId;

# Key vault
$kv=Get-AzureRmKeyVault -VaultName 'MyTest' -ResourceGroupName $resourceGroupname 
$kv=New-AzureRmKeyVault -VaultName 'MyTestOSDemo' -ResourceGroupName $resourceGroupname -Location 'West europe'

$secret = Set-AzureKeyVaultSecret -VaultName $kv.VaultName -Name 'Mysecret' -SecretValue ("Mysecret"|ConvertTo-SecureString -AsPlainText -Force) 


$secretFetch = Get-AzureKeyVaultSecret -VaultName $kv.VaultName -Name MySecret 

# ArmViz

# Start group deployment
AzureRM\New-AzureRmResourceGroupDeployment -Name "demodeployment$((Get-date).ToString("DDMMyyyy:hhii"))" -ResourceGroupName $resourceGroupname -Mode Incremental -TemplateFile .\Templates\ARM\DeployVM.json


$amAccount = New-AzureRmAutomationAccount -ResourceGroupName $resourceGroupname -Name 'opensourceautomationaccount' -Location 'west europe' -Plan Free; 


$dscDocument = 'C:\git\haraldfianbakken\azure-demo\MSOpenSourceAndCloud2016\Templates\DSC\ServerConfiguration.ps1'
$config = Import-PowerShellDataFile (Join-Path (Split-Path $dscDocument) ConfigData.psd1)

Import-AzureRmAutomationDscConfiguration -SourcePath $dscDocument -force -Published -Verbose -AutomationAccountName $amAccount.AutomationAccountName -ResourceGroupName $amAccount.ResourceGroupName

$params = @{}

$job = Start-AzureRmAutomationDscCompilationJob -ResourceGroupName $resourceGroupname -ConfigurationName 'ServerConfiguration' -Parameters $params -ConfigurationData $config -AutomationAccountName $amAccount.AutomationAccountName -Verbose 

$job|Get-AzureRmAutomationDscCompilationJob;

# Show onboarding of VM

# Clean up the demo

Remove-AzureRmResource $resourceGroupname -Force
