class ModelBooks {
  List<Books>? books;
  List<Categories>? categories;
  String? lastUpdate;

  ModelBooks({this.books, this.categories, this.lastUpdate});

  ModelBooks.fromJson(Map<String, dynamic> json) {
    if (json['books'] != null) {
      books = <Books>[];
      json['books'].forEach((v) {
        books!.add(new Books.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    lastUpdate = json['last_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.books != null) {
      data['books'] = this.books!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    data['last_update'] = this.lastUpdate;
    return data;
  }
}

class Books {
  int? id;
  int? part;
  int? categoryId;
  String? title;
  int? dateTime;
  String? updatedAt;
  int? idShow;
  int? bookCode;
  String? description;
  int? internationalNumber;
  String? publisher;
  int? changedPages;
  String? deletedAt;
  String? photoUrl;
  String? pdfLink;
  String? epubLink;
  String? soundUrl;
  String? writerName;
  String? scholarName;

  Books(
      {this.id,
      this.part,
      this.categoryId,
      this.title,
      this.dateTime,
      this.updatedAt,
      this.idShow,
      this.bookCode,
      this.description,
      this.internationalNumber,
      this.publisher,
      this.changedPages,
      this.deletedAt,
      this.photoUrl,
      this.pdfLink,
      this.epubLink,
      this.soundUrl,
      this.writerName,
      this.scholarName});

  Books.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    part = json['part'];
    categoryId = json['category_id'];
    title = json['title'];
    dateTime = json['date_time'];
    updatedAt = json['updated_at'];
    idShow = json['id_show'];
    bookCode = json['book_code'];
    description = json['description'];
    internationalNumber = json['international_number'];
    publisher = json['publisher'];
    changedPages = json['changed_pages'];
    deletedAt = json['deleted_at'];
    photoUrl = json['photo_url'];
    pdfLink = json['pdf_link'];
    epubLink = json['epub_link'];
    soundUrl = json['sound_url'];
    writerName = json['writer_name'];
    scholarName = json['scholar_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['part'] = this.part;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['date_time'] = this.dateTime;
    data['updated_at'] = this.updatedAt;
    data['id_show'] = this.idShow;
    data['book_code'] = this.bookCode;
    data['description'] = this.description;
    data['international_number'] = this.internationalNumber;
    data['publisher'] = this.publisher;
    data['changed_pages'] = this.changedPages;
    data['deleted_at'] = this.deletedAt;
    data['photo_url'] = this.photoUrl;
    data['pdf_link'] = this.pdfLink;
    data['epub_link'] = this.epubLink;
    data['sound_url'] = this.soundUrl;
    data['writer_name'] = this.writerName;
    data['scholar_name'] = this.scholarName;
    return data;
  }
}

class Categories {
  int? id;
  String? title;
  int? idShow;
  int? booksCount;

  Categories({this.id, this.title, this.idShow, this.booksCount});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    idShow = json['id_show'];
    booksCount = json['books_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['id_show'] = this.idShow;
    data['books_count'] = this.booksCount;
    return data;
  }
}
