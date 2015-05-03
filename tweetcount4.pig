
myrecords1 = LOAD '/user/cloudera/pigtweet/input1/input4.txt';

RawDataLowerCase = FOREACH myrecords1 GENERATE LOWER(((chararray)$0)) as tweets;

TokenizedData = FOREACH RawDataLowerCase GENERATE flatten(TOKENIZE(tweets)) as word;

ReplaceData = FOREACH TokenizedData GENERATE REPLACE(word, '.*dec.*', 'dec') as word;
ReplaceData = FOREACH ReplaceData GENERATE REPLACE(word, '.*hackathon.*', 'hackathon') as word;

FilteredData = FILTER ReplaceData BY (word == 'hackathon' OR word == 'dec' OR word == 'chicago' OR word == 'java');
wordGroup = GROUP FilteredData BY word;

wordCnt = FOREACH wordGroup GENERATE group AS tweetWord, COUNT(FilteredData);

DUMP wordCnt;
