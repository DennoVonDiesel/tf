resource "aws_guardduty_member" "member1" {
  detector_id        = "${aws_guardduty_detector.master.id}"
  account_id         = "111111111111"
  email              = "member1@my.domain"
  invite             = true
  invitation_message = "GuardDuty Invite from Master"
}
