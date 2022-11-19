import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
//create credentials
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "flutter-gsheet-tuto-369013",
  "private_key_id": "ad1199f36c98b911676715d5e1c71333ef7bab5a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDZ8BBrm1wKf8y7\nKmgr32uRqzueYJzGD/9WWGqJpkp9Q1mrG8wp2nD3yq1DPjS9o8FS+bn7HrGUkZlo\nE5qxDgAJY2pO3wD1pXmbCv/SXu3zBKidsQifumPrfjVWcnRWNsRtp8BffK1kI2zd\n5HG1jGDwLRTDmfB+CpHpcOVv09M7UAluzzURU7VPdSPbhFex3+UpW7hYGydpMScp\nKwNoXAUWtJp+Ff/LDTnipeeg5NfRRXCEsaLJhybBPpuOjaPWCOKvgnrt6iGabnX2\nCe38vgcZZxKrAtA97STM96nM/G5TS7cmhS+wSsSOihT16rX/2FYPxUw2yiBZV83y\nEOL2jBmvAgMBAAECggEANaAqii/aQAMeX1eZ9mGtWFSoANqI+PtqutZasLAoWBZA\ndCgM3qePcImAhLFDzP4ETeSA7NeqnoING1znjXWCcMzzlaCt3cPv3kSgmiUdq9ST\noOm004jLmWCewzy6f5ROVSUX4ucMyz0kRp01lZSLLc4J8+9nC7ySFrze19tpeIhO\n4j1T/PhDCz8oslMNuokI0Dc9aWRUtlUSUFUlNgk1LUCQU9KTpLl4vucB9hptxjfD\n5TUoQOevHno9+phoj36IFmz+HieSA0T1jEoEAdomRzmf9QeYtyptMlT2UiFleINV\nU7ic7mi36o4WJpel57EdAr5Jy8K4xZ1mfkKakvBn8QKBgQDyUEum2qPGSznGG64x\nQzvJZAwOzZ5Aj22iHzvzVffd/yl2ZevshSgAYVA7AdrKxnKX2Z+h5GCnm3ZE+1RM\np65p1N8AMdL5mbMuPsCmElFUdoumltmCuyd4Uf72UymkGuh79X3hMZySsPSc9bpf\nlxRlidw1U+upm2DQVHgZAP12YwKBgQDmP07pE8pBEPXdziDC/3DHdGlSePdL1jYQ\nNVg51gcjRlC6TB/sfFQy/ZOCcI0Vw2S8VPKcgC+8S6OAP9/Ji8a24Ngs/hqE49Lb\nfgQoEpX4fvsvZOiZstrwwzM81zRdKRpmOkzsh6vXEnqxPDMPZSE1tWNJVgy3D+ij\nUveMoCJbRQKBgQDNDTvnt8+txwzd46C12WJnmz1E7aWElps8/Vd7JP27I+lPYxKR\ntWDTaYY+WORwghyI+cVHd35/d2RPHawJrkA/GL+ZZ5BUXket07atEoU2h5bH45Gv\nOnc9L44lntx3Hbos4+KhRZ1s2Ug25w7PQ4ckIdRyYFDl1zHHOiPjbN4QZwKBgClz\nACupamGoQfq6Ht+7yHu/ky5LpIk8eOMWF1niE8rf36yKA7047Jd5WtLCnENst3fH\n+xz9XpqRK0/tL8ZCqXVGqOQAopmFwfHNj8X/AoyHn4R6r/zrW8q3+UNcooqa2avJ\nlwuFqQPAyeGaKr78v6vBiawsF4HlFUZBq1rfgQ/ZAoGBALIxwtP35cVZTYvOSjXg\nj+mXeMpt1ObC1YqYERY/+5/AGun0BWDCv2P7ZX74KjOn5o4+ZFkOcG5blY1JRXmV\nu6KnD23zW6/iwkOlRxEg5WVJBUFh0J3YWiPQnAFUSczzKlnFPZNLRxObzxu/4t9y\njifOrlx9vV9ph5FtIrzhByV1\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheet-tuto@flutter-gsheet-tuto-369013.iam.gserviceaccount.com",
  "client_id": "109719107845966632634",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheet-tuto%40flutter-gsheet-tuto-369013.iam.gserviceaccount.com"
}
''';
  static const _spreadsheetId = "1SDrFQysJ-M78smbuOR-aTo58C1kDEE_XAURceO2F2gM";

  final gsheets = GSheets(_credentials); //init gsheets
  static Worksheet? _worksheet;

// var to keep track of (show data)
  static int numberOfNotes = 0;
  static List<String> currentNotes = [];

  Future init() async {
    final ss = await gsheets
        .spreadsheet(_spreadsheetId); //fetch spreadsheet by its type
    _worksheet =
        ss.worksheetByTitle('Worksheet1'); // get worksheet by its title
    countRows();
  }

  //count the number of notes
  static Future countRows() async {
    while (
        (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
            '') {
      numberOfNotes++;
    }
    //now we know how many notes to load , let's load them
    loadNotes();
  }

//load existing notes from spreadsheet
  static Future loadNotes() async {
    if (_worksheet == null) return;
    for (int i = 0; i < numberOfNotes; i++) {
      final String newNote =
          await _worksheet!.values.value(column: 1, row: i + 1);
      if (currentNotes.length < numberOfNotes) {
        currentNotes.add(newNote);
      }
    }
  }

  //insert a new note
  static Future insert(String note) async {
    if (_worksheet == null) return;
    numberOfNotes++;
    currentNotes.add(note);
    await _worksheet!.values.appendRow([note]);
  }
}
