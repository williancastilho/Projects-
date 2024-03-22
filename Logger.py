import datetime


class Logger:
    def __init__(self, path):
        self.aPath = path

    def get_path(self):
        return self.aPath

    def write_log(self, message, level):
        with open(self.get_path(), 'a') as file:
            timestamp = datetime.datetime.now().strftime("[%Y-%m-%d %H:%M:%S]")
            file.write(f"{timestamp} [{level}] {message}\n")


if __name__ == "__main__":
    x_logger = Logger("C:/temp/app_log.log")

    x_logger.write_log("User logged in", "INFO")

    x_logger.write_log("Failed login attempt", "WARNING")
