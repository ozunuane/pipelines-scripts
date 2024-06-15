module "gke-cba" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"

  project_id                 = var.project
  name                       = "cba-cluster"
  kubernetes_version         = "1.22"
  region                     = var.region
  zones                      = [var.region_zone, var.region_zone_backup]
  network                    = var.network.name
  subnetwork                 = var.private_subnet.name
  ip_range_pods              = "ip-pods-secondary-range"
  ip_range_services          = "ip-services-secondary-range"
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  create_service_account     = true
  cluster_resource_labels    = { "mesh_id" : "proj-${data.google_project.project.number}" }
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "172.2.0.0/28"
  master_authorized_networks = [
    
    {
      cidr_block = var.private_subnet.ip_cidr_range
      display_name = "private subnet"
    },
    {
      cidr_block = var.public_subnet.ip_cidr_range
      display_name = "public subnet"
    }
    
    
  ]

  node_pools = flatten([
    var.k8_spot_instance_percent < 100 ? [
      {
        name               = "default-node-pool"
        machine_type       = var.k8_node_instance_type
        node_locations     = "${var.region_zone},${var.region_zone_backup}"
        initial_node_count = ceil(var.k8_min_node_count * (1 - (var.k8_spot_instance_percent / 100)))
        min_count          = ceil(var.k8_min_node_count * (1 - (var.k8_spot_instance_percent / 100)))
        max_count          = ceil(var.k8_max_node_count * (1 - (var.k8_spot_instance_percent / 100)))
        spot               = false
        local_ssd_count    = 0
        disk_size_gb       = 100
        disk_type          = "pd-standard"
        image_type         = "COS_CONTAINERD"
        enable_gcfs        = false
        enable_gvnic       = false
        auto_repair        = true
        auto_upgrade       = true
        preemptible        = false
    }] : [],


    var.k8_spot_instance_percent > 0 ? [
      {
        name               = "spot-node-pool"
        machine_type       = var.k8_node_instance_type
        node_locations     = "${var.region_zone},${var.region_zone_backup}"
        initial_node_count = ceil(var.k8_min_node_count * (var.k8_spot_instance_percent / 100))
        min_count          = ceil(var.k8_min_node_count * (var.k8_spot_instance_percent / 100))
        max_count          = ceil(var.k8_max_node_count * (var.k8_spot_instance_percent / 100))
        spot               = true
        local_ssd_count    = 0
        disk_size_gb       = 100
        disk_type          = "pd-standard"
        image_type         = "COS_CONTAINERD"
        enable_gcfs        = false
        enable_gvnic       = false
        auto_repair        = true
        auto_upgrade       = true
        preemptible        = false
    }] : [],
  ])

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}
  }

  node_pools_metadata = {
    all = {}
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []
  }
}


module "gke-noncba" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"

  project_id                 = var.project
  name                       = "noncba-cluster"
  kubernetes_version         = "1.22"
  region                     = var.region
  zones                      = [var.region_zone, var.region_zone_backup]
  network                    = var.network.name
  subnetwork                 = var.private_subnet.name
  ip_range_pods              = "ip-pods-secondary-range"
  ip_range_services          = "ip-services-secondary-range"
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  create_service_account     = true
  cluster_resource_labels    = { "mesh_id" : "proj-${data.google_project.project.number}" }
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "172.1.0.0/28"
  master_authorized_networks = [

    {
      cidr_block = var.private_subnet.ip_cidr_range
      display_name = "private subnet"
    },
    {
      cidr_block = var.public_subnet.ip_cidr_range
      display_name = "public subnet"
    }

  ]

  node_pools = flatten([
    var.k8_spot_instance_percent < 100 ? [
      {
        name               = "default-node-pool"
        machine_type       = var.k8_node_instance_type
        node_locations     = "${var.region_zone},${var.region_zone_backup}"
        initial_node_count = ceil(var.k8_min_node_count * (1 - (var.k8_spot_instance_percent / 100)))
        min_count          = ceil(var.k8_min_node_count * (1 - (var.k8_spot_instance_percent / 100)))
        max_count          = ceil(var.k8_max_node_count * (1 - (var.k8_spot_instance_percent / 100)))
        spot               = false
        local_ssd_count    = 0
        disk_size_gb       = 100
        disk_type          = "pd-standard"
        image_type         = "COS_CONTAINERD"
        enable_gcfs        = false
        enable_gvnic       = false
        auto_repair        = true
        auto_upgrade       = true
        preemptible        = false
    }] : [],


    var.k8_spot_instance_percent > 0 ? [
      {
        name               = "spot-node-pool"
        machine_type       = var.k8_node_instance_type
        node_locations     = "${var.region_zone},${var.region_zone_backup}"
        initial_node_count = ceil(var.k8_min_node_count * (var.k8_spot_instance_percent / 100))
        min_count          = ceil(var.k8_min_node_count * (var.k8_spot_instance_percent / 100))
        max_count          = ceil(var.k8_max_node_count * (var.k8_spot_instance_percent / 100))
        spot               = true
        local_ssd_count    = 0
        disk_size_gb       = 100
        disk_type          = "pd-standard"
        image_type         = "COS_CONTAINERD"
        enable_gcfs        = false
        enable_gvnic       = false
        auto_repair        = true
        auto_upgrade       = true
        preemptible        = false
    }] : [],
  ])

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}
  }

  node_pools_metadata = {
    all = {}
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []
  }
}
