part of 'game_defines.dart';

enum GameLanguage {
  afrikaans('af', 'afrikaans'),
  amharic('am', 'amharic'),
  arabic('ar', 'arabic'),
  assamese('as', 'assamese'),
  azerbaijani('az', 'azerbaijani'),
  bashkir('ba', 'bashkir'),
  belarusian('be', 'belarusian'),
  bemba_language('bem', 'bemba language'),
  bulgarian('bg', 'bulgarian'),
  bislama('bi', 'bislama'),
  bengali('bn', 'bengali'),
  tibetan_language('bo', 'tibetan language'),
  bosnian('bs', 'bosnian'),
  catalan('ca', 'catalan'),
  cebuano('ceb', 'cebuano'),
  corsican('co', 'corsican'),
  seychellois_creole('crs', 'seychellois creole'),
  czech('cs', 'czech'),
  welsh('cy', 'welsh'),
  danish('da', 'danish'),
  german('de', 'german'),
  ewe_language('ee', 'ewe language'),
  maldivian('dv', 'maldivian'),
  greek('el', 'greek'),
  english('en', 'english'),
  esperanto('eo', 'esperanto'),
  spanish('es', 'spanish'),
  estonian('et', 'estonian'),
  basque('eu', 'basque'),
  persian('fa', 'persian'),
  finnish('fi', 'finnish'),
  filipino('fil', 'filipino'),
  fijian('fj', 'fijian'),
  faroese('fo', 'faroese'),
  french('fr', 'french'),
  frisian('fy', 'frisian'),
  irish('ga', 'irish'),
  scottish_gaelic('gd', 'scottish gaelic'),
  galician('gl', 'galician'),
  gujarati('gu', 'gujarati'),
  hausa('ha', 'hausa'),
  hawaiian('haw', 'hawaiian'),
  hebrew('he', 'hebrew'),
  hindi('hi', 'hindi'),
  croatian('hr', 'croatian'),
  upper_sorbian('hsb', 'upper sorbian'),
  haitian_creole('ht', 'haitian creole'),
  hungarian('hu', 'hungarian'),
  armenian('hy', 'armenian'),
  indonesian('id', 'indonesian'),
  igbo_language('ig', 'igbo language'),
  innunaton('ikt', 'innunaton'),
  icelandic('is', 'icelandic'),
  italian('it', 'italian'),
  inuit_language('iu', 'inuit language'),
  japanese('ja', 'japanese'),
  indonesian_javanese('jv', 'indonesian javanese'),
  georgian('ka', 'georgian'),
  kekeqi_language('kek', 'kekeqi language'),
  congolese('kg', 'congolese'),
  kazakh('kk', 'kazakh'),
  cambodian('km', 'cambodian'),
  kurdish_north('kmr', 'kurdish north'),
  kannada('kn', 'kannada'),
  korean('ko', 'korean'),
  kurdish_central('ku', 'kurdish central'),
  kyrgyz('ky', 'kyrgyz'),
  latin('la', 'latin'),
  luxembourgish('lb', 'luxembourgish'),
  luganda('lg', 'luganda'),
  lingala('ln', 'lingala'),
  lao_language('lo', 'lao language'),
  lithuanian('lt', 'lithuanian'),
  latvian('lv', 'latvian'),
  malagasy('mg', 'malagasy'),
  malian('mhr', 'malian'),
  maori('mi', 'maori'),
  macedonian('mk', 'macedonian'),
  malayalam('ml', 'malayalam'),
  mongolian('mn', 'mongolian'),
  marathi('mr', 'marathi'),
  mountain_mali('mrj', 'mountain mali'),
  malay('ms', 'malay'),
  maltese('mt', 'maltese'),
  myanmar('my', 'myanmar'),
  bokmal_language('nb', 'bokmal language'),
  nepali('ne', 'nepali'),
  dutch('nl', 'dutch'),
  norwegian('no', 'norwegian'),
  chichewa('ny', 'chichewa'),
  oromo_language('om', 'oromo language'),
  oriya('or', 'oriya'),
  ossetian('os', 'ossetian'),
  queretaro_otomi_language('otq', 'queretaro otomi language'),
  punjabi('pa', 'punjabi'),
  papiamento_language('pap', 'papiamento language'),
  polish('pl', 'polish'),
  dar('prs', 'dar'),
  pashto('ps', 'pashto'),
  portuguese('pt', 'portuguese'),
  lundi_language('rn', 'lundi language'),
  romanian('ro', 'romanian'),
  russian('ru', 'russian'),
  kinyarwanda('rw', 'kinyarwanda'),
  sindhi('sd', 'sindhi'),
  sango('sg', 'sango'),
  sinhala('si', 'sinhala'),
  slovak('sk', 'slovak'),
  slovenian('sl', 'slovenian'),
  samoan('sm', 'samoan'),
  shona('sn', 'shona'),
  somali('so', 'somali'),
  albanian('sq', 'albanian'),
  serbian('sr', 'serbian'),
  sesotho('st', 'sesotho'),
  indonesian_sundanese('su', 'indonesian sundanese'),
  swedish('sv', 'swedish'),
  swahili('sw', 'swahili'),
  tamil('ta', 'tamil'),
  telugu('te', 'telugu'),
  tajik('tg', 'tajik'),
  setswana('tn', 'setswana'),
  thai('th', 'thai'),
  tigrinya('ti', 'tigrinya'),
  tigray('tig', 'tigray'),
  turkmen('tk', 'turkmen'),
  klingon('tlh', 'klingon'),
  tongan('to', 'tongan'),
  papuan_pidgin_language('tpi', 'papuan pidgin language'),
  turkish('tr', 'turkish'),
  tsonga_language('ts', 'tsonga language'),
  tatar('tt', 'tatar'),
  twi_language('tw', 'twi language'),
  tahitian('ty', 'tahitian'),
  udmurt_language('udm', 'udmurt language'),
  ukrainian('uk', 'ukrainian'),
  urdu('ur', 'urdu'),
  uzbek('uz', 'uzbek'),
  vietnamese('vi', 'vietnamese'),
  warri('war', 'warri'),
  south_african_xhosa('xh', 'south african xhosa'),
  yiddish('yi', 'yiddish'),
  yoruba('yo', 'yoruba'),
  yucatan_mayan('yua', 'yucatan mayan'),
  cantonese('yue', 'cantonese'),
  simplified_chinese('zh_CN', 'simplified chinese'),
  traditional_chinese('zh_TW', 'traditional chinese'),
  zulu('zu', 'zulu');

  const GameLanguage(this.languageCode, this.languageName);

  final String languageCode;
  final String languageName;
}
