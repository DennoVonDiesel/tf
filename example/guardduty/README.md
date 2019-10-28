AWS GuardDuty Configuration

AWS GuardDuty is a service that continously monitors security by analyzing VPC flow, AWS CloudTrail event, and DNS logs. For further information see:

https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html

To centralize GuardDuty configuration (events, notifications, etc.) determine the master GuardDuty account. Invitations to join the organization must be accepted by member accounts from the AWS Console per region.

All AWS accounts associated with the enterprise should be added to the directory accounts. To bootstrap AWS GuardDuty, run terraform in the directory global:

	cd global
	terraform init
	terraform apply

This will create global resources, i.e. IAM roles and policies.

GuardDuty is regional and will need to be configured per region. To initialize a region, for example, us-west-1:

	mkdir us-west-1
	ln -s ../main.tf
	[create backend.conf]
	[create variables.tf]

Example backend.conf:

	bucket  = "tfstate"
	key     = "master/us-west-1/guardduty.tfstate"
	region  = "us-west-1"
	profile = "master"

Example variables.tf:

	variable "region" {
	  description = "AWS Region"
	  type        = "string"

	  default = "us-west-1"
	}

To add add an account to the regional GuardDuty configuration:

	ln -s ../accounts/account-name.tf

Run terraform to initalize or modify a region:

	terraform init -backend-config=backend.conf
	terraform apply

GuardDuty generates CloudWatch events called GuardDuty findings. An event rule for GuardDuty findings triggers the Lambda function GuardDuty2Slack (located in the module directory lambda). If the code or configuration file is updated, run terraform for every region.  The configuration file is straight forward

	# Define colors for the alerts sent to slack
	colors:
	  low: [hex color]
	  medium: [hex color]
	  high: [hex color]

	# Format of GuardDuty finding URL
	url: "https://console.aws.amazon.com/guardduty/home?region=%s#/findings?macros=current&fId=%s"

	# Default webhook for unconfigured accounts
	webhook: https://hooks.slack.com/services/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

	# Account specific settings
	accounts:
	  [Account ID]: 
	      name: [Account Name]
	      severity: [Severity level to alert on: low, medium, or high]
	      webhook: [Slack Webhook URL]

To test the lambda function you can upload test/event.json from the AWS Console. You can also generate sample findings under GuardDuty settings from the AWS Console.
