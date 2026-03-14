class RealPersonEndpoints {
  const RealPersonEndpoints({
    this.token = '/member/real/person/token',
    this.result = '/member/real/person/result',
    this.image = '/member/real/person/image',
    this.upload = '/member/real/person/upload',
    this.uploadUserId = '/member/real/person/upload/userId',
    this.identify = '/member/real/person/identify',
  });

  final String token;
  final String result;
  final String image;
  final String upload;
  final String uploadUserId;
  final String identify;
}
