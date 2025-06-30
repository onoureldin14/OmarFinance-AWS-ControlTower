data "external" "baselines" {
  program = ["${path.module}/python/get_baseline_arns.py"]
}
