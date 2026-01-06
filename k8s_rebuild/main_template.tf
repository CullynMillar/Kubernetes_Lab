terraform {
  required_providers {
    hyperv = {
      source = "taliesins/hyperv"
      version = "1.2.1"
    }
  }
}

provider "hyperv" {
  # Configuration options
    user            = "<replace with user>"
    password        = "<replace with password>"
    host            = "<replace with host name>"
    port            = 5986
    https           = true
    insecure        = false
    use_ntlm        = true
    tls_server_name = ""
    cacert_path     = ""
    cert_path       = ""
    key_path        = ""
    script_path     = "C:/Temp/terraform_%RAND%.cmd"
    timeout         = "30s"
}

resource "hyperv_network_switch" "test_switch" {
    #Config options go here
    name = "Main Kubernetes Switch"
}

resource "hyperv_vhd" "master_node_vhd"{
    #Config options go here
    path = "<path to vhd for master node>"
    size = 53687091200 #50GB
}
resource "hyperv_vhd" "worker_node_vhd"{
    #Config options go here
    path = "<path to vhd for worker node>"
    size = 53687091200 #50GB
}
resource "hyperv_machine_instance" "master"{
    #Required settings
    name = "Master_Node"
    generation = 2
    #Optional settings
    automatic_start_action = "StartIfRunning"
    static_memory = true
    memory_startup_bytes = 4000000000
    #Nested components
    vm_firmware {
        enable_secure_boot = "On"
        secure_boot_template = "MicrosoftUEFICertificateAuthority"
        preferred_network_boot_protocol = "IPv4"
        console_mode                    = "None"
        pause_after_boot_failure        = "Off"
        boot_order {
            boot_type           = "HardDiskDrive"
            controller_number   = "0"
            #Testing out if this changes the UI outcome for the install (revert back to "1" and change DvdDrive back if it doesn't work)
            controller_location = "0"
        }
        boot_order {
            boot_type         = "DvdDrive"
            controller_number   = "0"
            controller_location = "1"
        }
        boot_order {
            boot_type            = "NetworkAdapter"
            network_adapter_name = "Main Kubernetes Switch"
        }
    }
    vm_processor{
        #Enter data here
        compatibility_for_migration_enabled               = false
        compatibility_for_older_operating_systems_enabled = false
        hw_thread_count_per_core                          = 0
        maximum                                           = 100
        reserve                                           = 0
        relative_weight                                   = 100
        maximum_count_per_numa_node                       = 0
        maximum_count_per_numa_socket                     = 0
        enable_host_resource_protection                   = false
        expose_virtualization_extensions                  = false
    }
    integration_services = {
        "Guest Service Interface" = false
        "Heartbeat"               = true
        "Key-Value Pair Exchange" = true
        "Shutdown"                = true
        "Time Synchronization"    = true
        "VSS"                     = true
    }
    network_adaptors{
        name = "Test Network"
        switch_name = hyperv_network_switch.test_switch.name
    }
    dvd_drives{
        controller_number   = "0"
        controller_location = "1"
        path = "<path to master dvd iso in project>"
    }
    hard_disk_drives{
        controller_type = "Scsi"
        controller_number = "0"
        controller_location = "0"
        path = hyperv_vhd.master_node_vhd.path
    }
}
resource "hyperv_machine_instance" "worker"{
    #Required settings
    name = "Worker_Node"
    generation = 2
    #Optional settings
    automatic_start_action = "StartIfRunning"
    static_memory = true
    memory_startup_bytes = 4000000000
    #Nested components
    vm_firmware {
        enable_secure_boot = "On"
        secure_boot_template = "MicrosoftUEFICertificateAuthority"
        preferred_network_boot_protocol = "IPv4"
        console_mode                    = "None"
        pause_after_boot_failure        = "Off"
        boot_order {
            boot_type           = "HardDiskDrive"
            controller_number   = "0"
            #Testing out if this changes the UI outcome for the install (revert back to "1" and change DvdDrive back if it doesn't work)
            controller_location = "0"
        }
        boot_order {
            boot_type         = "DvdDrive"
            controller_number   = "0"
            controller_location = "1"
        }
        boot_order {
            boot_type            = "NetworkAdapter"
            network_adapter_name = "Main Kubernetes Switch"
        }
    }
    vm_processor{
        #Enter data here
        compatibility_for_migration_enabled               = false
        compatibility_for_older_operating_systems_enabled = false
        hw_thread_count_per_core                          = 0
        maximum                                           = 100
        reserve                                           = 0
        relative_weight                                   = 100
        maximum_count_per_numa_node                       = 0
        maximum_count_per_numa_socket                     = 0
        enable_host_resource_protection                   = false
        expose_virtualization_extensions                  = false
    }
    integration_services = {
        "Guest Service Interface" = false
        "Heartbeat"               = true
        "Key-Value Pair Exchange" = true
        "Shutdown"                = true
        "Time Synchronization"    = true
        "VSS"                     = true
    }
    network_adaptors{
        name = "Test Network"
        switch_name = hyperv_network_switch.test_switch.name
    }
    dvd_drives{
        controller_number   = "0"
        controller_location = "1"
        path = "<path to dvd iso in project>"
    }
    hard_disk_drives{
        controller_type = "Scsi"
        controller_number = "0"
        controller_location = "0"
        path = hyperv_vhd.worker_node_vhd.path
    }
}