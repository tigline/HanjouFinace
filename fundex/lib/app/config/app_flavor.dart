enum AppFlavor { dev, staging, prod }

AppFlavor parseAppFlavor(String value) {
  switch (value.toLowerCase()) {
    case 'dev':
    case 'development':
      return AppFlavor.dev;
    case 'staging':
    case 'stage':
      return AppFlavor.staging;
    case 'prod':
    case 'production':
      return AppFlavor.prod;
    default:
      return AppFlavor.dev;
  }
}
