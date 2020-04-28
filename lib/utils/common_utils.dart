class CommonUtils {
  // 格式化GMT时间
  static String formatGMTTime(String string) {
    var monthsNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "July",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec"
    ];
    var list = string.split(" ");
    var day = list[1];
    var month = list[2];
    var year = list[3];
    var time = list[4];

    var monthIdx = monthsNames.indexOf(month) + 1;
    String monStr = '';
    if (monthIdx < 10) {
      monStr = '0' + monthIdx.toString();
    }
    var date = year + '-' + monStr + '-' + day + " " + time;
    return date;
  }
}
