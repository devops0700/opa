package terraform.analysis

import input as tfplan

########################
# Parameters for Policy
########################

# acceptable score for automated authorization
blast_radius = 2

# weights assigned for each operation on each resource-type
weights = {
    "aws_vpc": {"delete": 10, "create": 1, "modify": 10},
    "aws_subnet": {"delete": 10, "create": 2, "modify": 10}
}

# Consider exactly these resource types in calculations
resource_types = {"aws_vpc", "aws_subnet"}


#########
# Policy
#########

# Authorization holds if score for the plan is acceptable.
default authz = false
authz {
    score < blast_radius
}

# Compute the score for a Terraform plan as the weighted sum of creations
score = s {
    all := [ x |
            some resource_type
            crud := weights[resource_type];
            new := crud["create"] * num_creates[resource_type];
            x := new
    ]
    s := sum(all)
}

####################
# Terraform Library
####################

# list of all resources of a given type
resources[resource_type] = all {
    some resource_type
    resource_types[resource_type]
    all := [name |
        name:= tfplan.resource_changes[_]
        name.type == resource_type
    ]
}


# number of creations of resources of a given type 
num_creates[resource_type] = num {
    some resource_type
    resource_types[resource_type]
    all := resources[resource_type]
    creates := [res |  res:= all[_]; res.change.actions[_] == "create"]
    num := count(creates)
}
