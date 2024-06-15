## About this Module

This terraform module creates and manages three resources:

- ECR Repostory |
- Repository Policy |
- Life Cycle Policy |

## Modules

No modules required.

## Variable Inputs

- image_tag_mutability | Determines whether image would be mutable or immutable | `bool` | true = Mutable | false = Immutable
- image_scan_on_push | Determines whether image would sna on push | `bool` |
- encryption_type | Determines what encryption type to use | `string` | AES256 or KMS
- attach_repository_policy | Determines whether a repository policy will be attached to the repository | `bool` |
- create_lifecycle_policy | Determines whether a lifecycle policy will be created | `bool` |

- tagStatus | Determines the tag status | `string` | Defaults to "any" if not provided
- countType | Determines whether image would be mutable or immutable | `string` | Defaults to "imageCountMoreThan" if not provided
- countNumber | Determines whether image would be mutable or immutable | `string` | Defaults to "90" if not provided
- tagPrefixList | Determines whether image would be mutable or immutable | `string` | Defaults to "test" if not provided

## Outputs

| Full URL of the repository |
