#########################################################
# Control Tower Admin Role
#########################################################

resource "aws_iam_role" "controltower_admin" {
  name = "AWSControlTowerAdmin"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "controltower.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "controltower_admin_custom" {
  name        = "AWSControlTowerAdminPolicy"
  description = "Custom policy for AWSControlTowerAdmin role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ec2:DescribeAvailabilityZones"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_custom_policy" {
  role       = aws_iam_role.controltower_admin.name
  policy_arn = aws_iam_policy.controltower_admin_custom.arn
}

resource "aws_iam_role_policy_attachment" "attach_managed_policy" {
  role       = aws_iam_role.controltower_admin.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSControlTowerServiceRolePolicy"
}

#########################################################
# Control Tower StackSet Role
#########################################################

resource "aws_iam_role" "controltower_stackset_role" {
  name = "AWSControlTowerStackSetRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudformation.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "controltower_stackset_policy" {
  name        = "AWSControlTowerStackSetRolePolicy"
  description = "Allows STS assume role into AWSControlTowerExecution roles in target accounts"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sts:AssumeRole"
        ],
        Resource = "arn:aws:iam::*:role/AWSControlTowerExecution"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "controltower_stackset_attachment" {
  role       = aws_iam_role.controltower_stackset_role.name
  policy_arn = aws_iam_policy.controltower_stackset_policy.arn
}
