# asg-lifecycle
A module to create Autoscaling Group lifecycle hooks, this assumes the hook listens to an SNS queue.
Very handy if you are using lifecycled

## Usage
```
module "asg_lifecycle" {
	name			= "MyASGHook"
	worker_asg		= [ "myasg-1" ]
	worker_iam_role = "myworker-role-name" 
}
```
