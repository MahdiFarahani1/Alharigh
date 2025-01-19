String cssStyle() {
  String style = '''
                                      body {
                              font-family: Arial, sans-serif;
                              line-height: 1.6;
                              padding: 6px;
                             overflow: hidden; 
      }

    body::-webkit-scrollbar {
  display: none; 
}
                            h1, h2, h3 {
                              color: #333;
                            }
                            hr {
                              margin: 20px 0;
                            }
                            p div {
                              display: block !important;
                            }




                                :root {
                                  --border-color: #ff0000;
                                }

                                .show_setting {
                                  display: flex !important;
                                }
                                body {
                                  overflow-x: hidden !important;
                                  overflow-y: auto !important;
                                  position: relative;
                                }
                                .bg-active {
                                  border: 1px solid #005a63 !important;
                                }
                                html {
                                  /* scroll-behavior: smooth !important; */
                                }

                                @font-face {
                                  font-family: "AGC";
                                  src: url("./AGCRegular.ttf") format("truetype");
                                }

                                @font-face {
                                  font-family: "Jazeera";
                                  src: url("./Al-Jazeera-Arabic-Regular.ttf") format("truetype");
                                }

                                @font-face {
                                  font-family: "Bloom";
                                  src: url('assets/fonts/AGCRegular.ttf') format("truetype");
                                }

                                .pageLoading {
                                  width: 50px;
                                  text-align: center;
                                  margin: auto;
                                  vertical-align: middle;
                                }

                                #curpage {
                                  position: fixed;
                                  bottom: 0;
                                  left: 50%;
                                  padding: 10px 50px;
                                  background-color: #ccc;
                                }

                                .add_fav {
                                  background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAA4CAYAAACPKLr2AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyVpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTQ4IDc5LjE2NDAzNiwgMjAxOS8wOC8xMy0wMTowNjo1NyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDIxLjAgKE1hY2ludG9zaCkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RUY0NzZCRkRDRUY4MTFFREJFNDBFQzJBNUExN0E3MDIiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RUY0NzZCRkVDRUY4MTFFREJFNDBFQzJBNUExN0E3MDIiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDpFRjQ3NkJGQkNFRjgxMUVEQkU0MEVDMkE1QTE3QTcwMiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpFRjQ3NkJGQ0NFRjgxMUVEQkU0MEVDMkE1QTE3QTcwMiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Pk5r7tgAAAHGSURBVHja7JpNKERRFMfveyzMkiSsKVmRFcIKC7FRslJWlkONNCVhpXwUS0s2ysQKycfCAgs2thZjRVGTstGkef6nd1+93swb3pv3cRfn1K/mTd3mN/eee85072iGYQiVQxeKR3UykXAT7wZ9oAnUhPT53+AN3IB7UCgSLDFoHKyBlogn6xksgGO3JdbAFsjEIEfRCo7AunQpElwEcwqkXQqknYJtYEmhvbEK2u2CaZd8jCuqwLwlSA+jClaYMXIjwWZQq6BgHWgkwXqF63SDrng30ZVvdSzIgizIgizIgizIgizIgizIgizIgizIgiwYXwR5qko3QhvyNZ0zayoJvoNpcCqfz8GeMA9HY1/iS9Bhk6O4ku+dxCn4A1bAsDBvi5zxIcyz71mQj1rwBfSDZVHi+sqRl9ugR5g3SZEIHoJOcOdhzCPoArthCn6BKTABPn18MRo/43X8fwUf5AzsB7CprBW4DUKQcmgH9PrNoTI5PCA3WcGvINW2EZCsZBf+UQVokw2CV6+CVm07i6CbXZermSSYtc1QXrapIZfaFlZYNTPlcMlSq8tJISq4B+Appt8FlO+b4AJMynaZ0/hfHxXGrwADANuCU/Xn2SkEAAAAAElFTkSuQmCC') !important;
                                }
                                .page-number {
                                  position: absolute;
                                  display: flex;
                                  background-color: #eee;
                                  padding: 0px 6px 3px;
                                  right: 20px;
                                  top: 0;
                                  color: #ac2224;
                                  border-bottom-left-radius: 4px;
                                  border-bottom-right-radius: 4px;
                                  font-size: 14px !important;
                                }

                                .book-mark {
                                  position: absolute;
                                  display: flex;
                                  color: rgb(238, 238, 238);
                                  left: 20px;
                                  top: 0;
                                  transition: 0.3s;
                                  background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAA4CAYAAACPKLr2AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyVpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTQ4IDc5LjE2NDAzNiwgMjAxOS8wOC8xMy0wMTowNjo1NyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDIxLjAgKE1hY2ludG9zaCkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RUY0NzZCRjlDRUY4MTFFREJFNDBFQzJBNUExN0E3MDIiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RUY0NzZCRkFDRUY4MTFFREJFNDBFQzJBNUExN0E3MDIiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDpFRjQ3NkJGN0NFRjgxMUVEQkU0MEVDMkE1QTE3QTcwMiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpFRjQ3NkJGOENFRjgxMUVEQkU0MEVDMkE1QTE3QTcwMiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/Prro/OAAAAKZSURBVHja7JlNSFRRFMef45CKZghtSrSdoBNEm9CEPgzzYyFIWhHuChqI0M1QrbLtIH5RCwV3IhaJ0UJRKLOCWlak6LKPsU2QX+HHYux/8ry4nO7Im/HNm7e4B37wPO++ub+5884Z592swYEBS8RxcAPUgmMg30pv/AZfwDQYAp/VkwHl+AB4BD6AdlDhgZzFc9BcHTz3Q3b5G0FFbhLUWJmNbHALlIMGsG2vYI8P5NQgl277I6Z77qYYsAiaQSHISjOFPNeicAiDUJALIls5sQCqwLJHq7UGnoFZ8B6UKR/39QBXqxr3PJRT4xe4K3IXSbBUJF9k8N6Tc5eSYIFmyTMVq+LvgwHL52EEjaARNIJG0AgaQSNoBI2gETSCRtAIGkEj6A/BVvCdafWbID3THgXFzGPQ6QdBekIaBb3itSh/H/Tvd479XJwLnoDIHmNu82rmei1YBKZAi8ivMGq08NgirwSPghlwRuR/gHOgGnwT52jsW+v/p7muC9KOAD3oPiHy86DS2t2ImePjj2JMBV97Ml2C53kVSkT+HTgLviq5JV7NWTH2CHgN6twWvAQmwCGRHwcXwE/NNcssMiry9Ez8ObjmlmA7V6usxH4ugI09rt1ikajI09bbsJNeGUihx+2ABywed/AGafwda3ezMJ5sr0x0IgeMaHrcNmhL8VuiD1wGm5pe+RTkORWkfkV7t1dFfh00sXiqMQYaNb2S9upegsNOBN9oelyM+9uUC1+vdg+NiTy1pldOBEOaHncafHLxPx96rVOaXhlKtop1Pc6tSNQrHQvSjVuToMe5FdQr63mupASp9K9oKi4dscnVHU0kGBM9K5JEj3Mr7F4Z4eN/xUmCYb4flri1dGXwJ0gXO9g+4T8CDACkpYGV5RM+rwAAAABJRU5ErkJggg==');
                                  cursor: pointer;
                                  width: 15px;
                                  height: 20px;
                                  background-size: contain;
                                  background-repeat: no-repeat;
                                }

                                .comment-button {
                                  position: absolute;
                                  display: flex;
                                  color: rgb(238, 238, 238);
                                  left: 50px;
                                  top: 0;
                                  transition: 0.3s;
                                  background-image: url('data:image/jpeg;base64,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');
                                  cursor: pointer;
                                  width: 22px;
                                  height: 22px;
                                  background-size: contain;
                                  background-repeat: no-repeat;
                                }

                                .has-comment {
                                  background-image: url('data:image/jpeg;base64,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') !important;
                                }


                                .highlight { background-color: yellow }




                                .mark {
                                  background: #ffff00;
                                  color: red;
                                }

                                body {
                                  margin: 0;
                                  overflow: hidden;
                                  box-sizing: border-box !important;
                                }

                                .book_text_horizontal {
                                  max-height: 90vh;
                                  overflow-y: scroll;
                                  direction: rtl; padding: 0 5px; text-align: justify; font-size: 14px !important;
                                  line-height: 2.5;
                                }

                                .BookPage-horizontal {
                                  position: relative;
                                  margin-left: 10px;
                                  padding: 15px 10px;
                                  background-color: #fff;
                                  border: 1px solid rgba(170, 170, 170, 0.3333333333);
                                  border-radius: 4px;
                                  transition: 0.5s;
                                  text-align: justify;
                                  direction: rtl;
                                  right: 0;
                                  overflow-x: hidden !important;
                                  /* display: none !important; */
                                }

                                .book-container-horizontal {
                                  display: flex !important;
                                  overflow-x: auto !important;
                                  scroll-snap-type: x mandatory !important;
                                  box-sizing: border-box;
                                }

                                .book-page-horizontal {
                                  flex: 0 0 calc(100vw - 12px) !important;
                                  text-align: center !important;
                                  scroll-snap-align: start !important;
                                  box-sizing: border-box !important;
                                  overflow-y: auto !important;
                                }

                                .book_text_vertical {
                                  max-height: fit-content !important;
                                  direction: rtl; padding: 0 5px; text-align: justify; font-size: 14px !important;
                                  line-height: 2.5;
                                }

                                .BookPage-vertical {
                                  position: relative;
                                  margin-bottom: 10px;
                                  padding: 15px 10px;
                                  background-color: #fff;
                                  border: 1px solid rgba(170, 170, 170, 0.3333333333);
                                  border-radius: 4px;
                                  transition: 0.5s;
                                  text-align: justify;
                                  direction: rtl;
                                  right: 0;

                                  /* overflow-y: hidden !important; */
                                  /* display: none !important; */
                                }

                                /* .book-container-vertical { */
                                  /* display: flex; */
                                  /* flex-direction: column; */
                                  /* overflow-y: auto; */
                                  /* scroll-snap-type: y mandatory; */
                                  /* height: fit-content !important; */
                                /* } */

                                /* .book-page-vertical { */
                                  /* flex: 0 0 50vh; */
                                  /* width: calc(100vw - 12px) !important; */
                                  /* height: fit-content !important; */
                                  /* text-align: center; */
                                  /* scroll-snap-align: start; */
                                  /* box-sizing: border-box; */
                                  /* overflow-y: auto; */
                                /* } */


                                h1.tit1 {
                                  color: #00aa00;
                                  font-size: 150%;
                                  margin-top: 20px;
                                  margin-bottom: 0px;
                                  text-align: center;
                                  font-weight: bold;
                                  // font-family: inherit !important;
                                }
                                .dark h1.tit1 {
                                  color: #fff;
                                }
                                h2.tit2 {
                                  color: navy;
                                  font-size: 130%;
                                  margin-top: 20px;
                                  margin-bottom: 0px;
                                  text-align: center;
                                  font-weight: bold;
                                  font-family: inherit !important;
                                }
                                h2.tit3 {
                                  color: black;
                                  font-size: 130%;
                                  margin-top: 20px;
                                  margin-bottom: 0px;
                                  text-align: center;
                                  font-weight: bold;
                                  font-family: inherit !important;
                                }
                                h3.tit3 {
                                  color: #000;
                                  font-size: 120%;
                                  margin-top: 20px;
                                  text-align: center;
                                  margin-bottom: 10px;
                                  font-weight: bold;
                                  font-family: inherit !important;
                                }

                                h4.tit4 {
                                  color: black;
                                  font-size: 120%;
                                  margin-top: 20px;
                                  margin-bottom: 0px;
                                  font-weight: bold;
                                  text-align: center;
                                  font-family: inherit !important;
                                }
                                h5.tit5 {
                                  color: black;
                                  font-size: 120%;
                                  margin-top: 20px;
                                  margin-bottom: 10px;
                                  font-weight: bold;
                                  text-align: right;
                                  font-family: inherit !important;
                                }

                                p.pagen {
                                  text-align: center;
                                  color: red;
                                  text-indent: 0;
                                  font-size: 75%;
                                }

                                .fnote {
                                  color: #337777;
                                  font-size: 70% !important;
                                  margin: 0px 0px 10px;
                                  padding: 0px;
                                  text-indent: 0;
                                  line-height: 150%;
                                }
                                hr.fnote {
                                  border: 1px solid rgb(227, 227, 227);
                                  width: 40%;
                                  min-width: 300px;
                                }
                                .fnote_line {
                                  color: #337777;
                                  padding: 0;
                                  overflow-x: hidden !important;
                                  margin-top: 10px;
                                  margin-bottom: 0;
                                }
                                .fnote2 {
                                  color: #337777;
                                  font-size: 80%;
                                  margin: 0px;
                                  padding: 0px;
                                  text-indent: 5px;
                                }
                                .sher {
                                  text-align: center;
                                  color: #000;
                                  font-size: 80%;
                                  margin-top: 10px;
                                  margin-bottom: 10px;
                                  text-indent: 0;
                                }

                                .fn {
                                  color: #337777;
                                  font-size: 75%;
                                  text-decoration: none;
                                  vertical-align: top;
                                }

                                .fm {
                                  color: #008000;
                                  font-weight: bold;
                                  font-family: Simplified Arabic, serif;
                                  font-size: 75%;
                                  text-decoration: none;
                                }

                                .quran {
                                  font-weight: bold;
                                  color: green;
                                }

                                .hadith {
                                  font-weight: bold;
                                  color: #000;
                                }

                                .eng {
                                  font-weight: bold;
                                  color: #000;
                                }

                                .txtleft {
                                  font-weight: bold;
                                  color: green;
                                }

                                .paragraph {
                                  color: #000;
                                  margin: 0px;
                                }
                                .hashieh {
                                  overflow-x: hidden;
                                  width: 100%;
                                  color: #000;
                                }

                                .centertxt {
                                  text-align: center;
                                  color: rgb(204, 102, 0);
                                }
                                .centertxt2 {
                                  text-align: center;
                                  color: #000;
                                }
                                .empty {
                                  color: #f63;
                                  text-align: center;
                                  padding-top: 260px;
                                  font-weight: bold;
                                }
                                .short-texts {
                                  color: #000;
                                  font-weight: bold;
                                  direction: rtl;
                                }
                                .short-texts-line {
                                  margin: 0px;
                                  padding: 0;
                                  overflow-x: hidden !important;
                                  display: inline-block;
                                  margin-top: -10px;
                                }
                                .marging_text {
                                  color: #764c01;
                                }
                                p {
                                  text-indent: 1em;
                                  margin: 0 !important;
                                  padding: 0 !important;
                                }
                                p + p {
                                  margin: 0;
                                }

                                .dark h1.tit1,
                                .dark h2.tit2,
                                .dark h3.tit3,
                                .dark h4.tit4,
                                .dark h5.tit5,
                                .dark h6.tit6 {
                                  color: #337777;
                                }

                                /* SETTING */

                                .setting-Collapse {
                                  position: absolute;
                                  top: 55px;
                                  padding: 20px;
                                  background-color: white;
                                  border: 1px solid #aaa;
                                  border-radius: 10px;
                                  display: flex;
                                  margin-right: auto;
                                  z-index: 1;
                                  flex-direction: column;
                                  direction: rtl;
                                  width: 170p !important;
                                  /* right: 0; */
                                }
                                .show {
                                  display: block;
                                }
                                .setting-Collapse .range .sliderValue span::after {
                                  position: absolute;
                                  content: "";
                                  height: 30px;
                                  width: 30px;
                                  background: #4a6868;
                                  left: 50%;
                                  transform: translateX(-50%) rotate(45deg);
                                  z-index: -1;
                                  border-top-left-radius: 50%;
                                  border-top-right-radius: 50%;
                                  border-bottom-left-radius: 50%;
                                  top: 10px;
                                }
                                .range .sliderValue span.show {
                                  -webkit-transform: translateX(50%) scale(1) !important;
                                  transform: translateX(50%) scale(1) !important;
                                }
                                .setting-Collapse .range .sliderValue span {
                                  position: absolute;
                                  height: 45px;
                                  color: white;
                                  font-weight: 500;
                                  transform: translateX(50%) scale(0);
                                  transform-origin: bottom;
                                  transition: transform 0.3s ease-in-out;
                                  line-height: 49px;
                                  z-index: 2;
                                  top: -44px;
                                  width: 30px;
                                  right: 19px;
                                  text-align: center;
                                  padding-top: 15px;
                                  font-size: 14px !important;
                                }

                                .setting-Collapse .setting-part-title::before {
                                  content: "";
                                  position: absolute;
                                  right: 0;
                                  top: 13px;
                                  height: 1px;
                                  width: 40px;
                                  background-color: rgba(97, 97, 97, 0.3333333333);
                                }

                                .marker {
                                  position: absolute;
                                  width: 25px;
                                  height: 20px;
                                  z-index: 2;
                                  top: 0;
                                  display: inline-block;
                                  background-color: #94b4a1;
                                  left: -1px;
                                  background-color: #94b4a1;
                                  background-image: linear-gradient(left, #94b4a1 0%, #94b4a1 100%);
                                  border-radius: 4px 0 0 4px;
                                  transition: all 0.4s;
                                  animation: markmove 2s;
                                }

                                .marker::after {
                                  content: "";
                                  position: absolute;
                                  border: 10px solid rgba(0, 0, 0, 0);
                                  border-left-color: rgba(0, 0, 0, 0);
                                  border-left-style: solid;
                                  border-left-width: 10px;
                                  border-left: 13px solid #94b4a1;
                                  left: 100%;
                                  top: 0;
                                }

                                .setting-Collapse .setting-part-title::after {
                                  content: "";
                                  position: absolute;
                                  left: 0;
                                  top: 13px;
                                  height: 1px;
                                  width: 40px;
                                  background-color: rgba(97, 97, 97, 0.3333333333);
                                }

                                .setting-Collapse .range .field {
                                  position: relative;
                                  display: flex;
                                  align-items: center;
                                  justify-content: center;
                                  height: 100%;
                                }

                                .setting-Collapse .range .field input {
                                  -webkit-appearance: none;
                                  direction: rtl;
                                  height: 5px;
                                  background: #dcddd5;
                                  border-radius: 5px;
                                  outline: none;
                                  border: none;
                                  width: 100%;
                                  margin: 0 5px;
                                }

                                .overlay-setting {
                                  position: fixed;
                                  display: none;
                                  justify-content: center;
                                  align-items: center;
                                  background-color: #0006;
                                  z-index: 2;
                                  width: 100%;
                                  height: 100%;
                                  top: 0;
                                  right: 0 !important;
                                }

                                .setting-Collapse .range .field input[type="range"]::-webkit-slider-,
                                .setting-Collapse .range .field input[type="range"]::-moz-range-thumb {
                                  -webkit-appearance: none;
                                  height: 12px;
                                  width: 12px;
                                  border: 1px solid #fff;
                                  background: #4a6c6d !important;
                                  border-radius: 50%;
                                  cursor: pointer;
                                }
                                .setting-Collapse .setting-part-title {
                                  margin: 0;
                                  text-align: center;
                                  position: relative;
                                  font-size: 14px !important;
                                  color: #616161;
                                }
                                .setting-Collapse .range {
                                  margin-top: 20px;
                                }

                                .setting-Collapse > div {
                                  margin: 15px 0;
                                  margin-top: 15px;
                                }
                                .setting-Collapse .bg-change a:hover {
                                  box-shadow: 0 0 4px 0px #aaa;
                                }
                                .radio-box {
                                  position: relative;
                                  margin: 25px auto;
                                  border-radius: 4px;
                                  border: 1px solid #ccc;
                                  background-color: #dcddd5;
                                  width: 100%;
                                }
                                /* .radio-box .radio-btn:nth-of-type(1) {
                                    top: 5px;
                                }
                                .radio-box .radio-btn:nth-of-type(2) {
                                    top: 31px;
                                }
                                .radio-box .radio-btn:nth-of-type(3) {
                                    top: 62px;
                                } */

                                .radio-box .radio-btn:nth-of-type(1):checked ~ .marker {
                                  top: 5px;
                                }
                                .radio-box .radio-btn:nth-of-type(2):checked ~ .marker {
                                  top: 36px;
                                }
                                .radio-box .radio-btn:nth-of-type(3):checked ~ .marker {
                                  top: 62px;
                                }

                                .active-font {
                                  color: #94b4a1 !important;
                                  background-color: rgba(255, 255, 255, 0.2) !important;
                                }

                                /* .radio-box .radio-btn:nth-of-type(3):checked + .radio-label,
                                .radio-box .radio-btn:nth-of-type(2):checked + .radio-label,
                                .radio-box .radio-btn:nth-of-type(1):checked + .radio-label {
                                    color: #94b4a1;
                                    background-color: rgba(255, 255, 255, 0.2);
                                } */

                                .radio-box .radio-btn:nth-of-type(1):hover ~ .marker {
                                  top: 7px !important;
                                }

                                .radio-box .radio-btn:nth-of-type(2):hover ~ .marker {
                                  top: 45px !important;
                                }
                                .radio-box .radio-btn:nth-of-type(3):hover ~ .marker {
                                  top: 81px !important;
                                }

                                .radio-btn {
                                  width: 100%;
                                  position: relative;
                                  height: 30px;
                                  position: absolute;
                                  /* top: 31px; */
                                  opacity: 0;
                                  z-index: 2;
                                  cursor: pointer;
                                  margin: 0;
                                }
                                .setting-Collapse .bg-change a {
                                  display: flex;
                                  justify-content: center;
                                  align-items: center;
                                  width: 30px;
                                  height: 30px;
                                  border-radius: 5px;
                                  border: 1px solid #aaa;
                                  transition: 0.3s;
                                }
                                .setting-Collapse .bg-change {
                                  display: flex;
                                  width: 100%;
                                  justify-content: space-between;
                                  margin-bottom: 20px;
                                }

                                .radio-label {
                                  display: block;
                                  color: #555;
                                  font-size: 24px;
                                  line-height: 1;
                                  border-bottom: 1px solid rgba(255, 255, 255, 0.4);
                                  text-shadow: 1px 1px 0 rgba(255, 255, 255, 0.7);
                                  box-shadow: 0 1px 0 rgba(0, 0, 0, 0.1);
                                  font-size: 15px;
                                  cursor: pointer;
                                  padding: 4px 10px 4px 50px;
                                }

                                .bg-change #bg-white {
                                  background-color: #fff;
                                }

                                .bg-change #bg-cream {
                                  background-color: #ebdca4;
                                }
                                .setting-Collapse .bg-change #bg-black {
                                  background-color: #2e353f;
                                }

                                .min-value {
                                  font-size: 15px !important;
                                }
                                .max-value {
                                  font-size: 25px !important;
                                }

                                /*  LOADING */
                                .container_loading {
                                  position: fixed;
                                  z-index: 110;
                                  background-color: #0006;
                                  width: 100%;
                                  height: 100%;
                                  left: 0;
                                  top: 0;
                                  display: none;
                                }
                                .loading {
                                  position: fixed;
                                  animation: spin 1.4s linear infinite;
                                  top: calc(50% - 100px);
                                  left: calc(50% - 100px);
                                  width: 200px;
                                  height: 200px;
                                }

                                .ring {
                                  position: absolute;
                                  top: 50%;
                                  left: 50%;
                                  stroke-dasharray: 60 440;
                                  stroke-dashoffset: -500;
                                  stroke-width: 10px;
                                  animation: shift 3.2s ease-in-out infinite;
                                }
                                .ring:nth-child(3) {
                                  stroke-width: 12px;
                                  opacity: 0.4;
                                }

                                @keyframes shift {
                                  0% {
                                  }
                                  50% {
                                    stroke-dasharray: 400 100;
                                    stroke-dashoffset: -350;
                                  }
                                  100% {
                                  }
                                }

                                @keyframes shift-test {
                                  to {
                                    stroke-dashoffset: 0;
                                  }
                                }

                                @keyframes spin {
                                  to {
                                    transform: rotate(360deg);
                                  }
                                }


                                /* //range// */

                                .info {
                                  position: absolute;
                                  top: 0;
                                  left: 0;
                                  padding: 10px;
                                  opacity: 0.5;
                                }

                                .container11 {
                                  position: fixed;
                                  right: 0px;
                                  top: 20px;
                                  height: calc(100% - 40px);
                                }
                                @media (min-height: 500px) {
                                  .container {
                                    position: absolute;
                                    top: 50%;
                                    transform: translate(-50%, -50%);
                                    padding-bottom: 0;
                                  }
                                }

                                .range-slider {
                                  display: inline-block;
                                  width: 40px;
                                  position: relative;
                                  text-align: center;
                                  max-height: 100%;
                                  height: 100%;
                                  rotate: 180deg;
                                }
                                .range-slider:before {
                                  position: absolute;
                                  top: -2em;
                                  left: 0.5em;
                                  content: attr(data-slider-value) "%";
                                  color: white;
                                  font-size: 90%;
                                }
                                .range-slider__thumb {
                                  position: absolute;
                                  left: 5px;
                                  width: 30px;
                                  height: 30px;
                                  background: white;
                                  color: #777;
                                  border: 1px solid gray;
                                  border-radius: 50%;
                                  pointer-events: none;
                                  rotate: 180deg;
                                  display: flex;
                                  justify-content: center;
                                  align-items: center;
                                  font-size: 16px !important;
                                }
                                .range-slider__bar {
                                  left: 16px;
                                  bottom: 0;
                                  position: absolute;
                                  background: linear-gradient(gray, gray);
                                  pointer-events: none;
                                  width: 8px;
                                  border-radius: 10px;
                                }
                                .range-slider input[type="range"][orient="vertical"] {
                                  position: relative;
                                  margin: 0;
                                  height: 100%;
                                  width: 100%;
                                  display: inline-block;
                                  position: relative;
                                  writing-mode: bt-lr;
                                }
                                .range-slider input[type="range"][orient="vertical"]::-webkit-slider-runnable-track,
                                .range-slider input[type="range"][orient="vertical"]::-webkit-slider-thumb {
                                  -webkit-appearance: none;
                                }
                                .range-slider input[type="range"][orient="vertical"]::-webkit-slider-runnable-track {
                                  /* border: none; */
                                  /* background: #343440; */
                                  width: 0px;
                                  /* border-color: #343440;
                                    border-radius: 10px;
                                    box-shadow: 0 0 0 2px #3D3D4A; */
                                }
                                .range-slider input[type="range"][orient="vertical"]::-moz-range-track {
                                  border: none;
                                  background: #343440;
                                  width: 0px !important;
                                  border-color: #343440;
                                  border-radius: 10px;
                                  box-shadow: 0 0 0 2px #3d3d4a;
                                }
                                .range-slider input[type="range"][orient="vertical"]::-ms-track {
                                  border: none;
                                  background: #343440;
                                  width: 0px !important;
                                  border-color: #343440;
                                  border-radius: 10px;
                                  box-shadow: 0 0 0 2px #3d3d4a;
                                  color: transparent;
                                  height: 100%;
                                }
                                .range-slider input[type="range"][orient="vertical"]::-ms-fill-lower,
                                .range-slider input[type="range"][orient="vertical"]::-ms-fill-upper,
                                .range-slider input[type="range"][orient="vertical"]::-ms-tooltip {
                                  display: none;
                                }
                                .range-slider input[type="range"][orient="vertical"]::-webkit-slider-thumb {
                                  width: 30px;
                                  height: 30px;
                                  opacity: 0;
                                }
                                .range-slider input[type="range"][orient="vertical"]::-moz-range-thumb {
                                  width: 30px;
                                  height: 30px;
                                  opacity: 0;
                                }
                                .range-slider input[type="range"][orient="vertical"]::-ms-thumb {
                                  width: 30px;
                                  height: 30px;

                                  opacity: 0;
                                }

                                .range-slider::-moz-range-track {
                                  width: 2px !important;
                                }

                                .theme1 {
                                  background: linear-gradient(pink, deeppink);
                                }

                                .theme2 {
                                  background: linear-gradient(tomato, red);
                                }

                                .theme3 {
                                  background: linear-gradient(yellow, orange);
                                } /*# sourceMappingURL=style.css.map */
























                                /* add range */


                                .range_page {
                                  margin-top: 20px;
                                  display: flex;
                                  rotate: -90deg;
                                  position: fixed;
                                  top: 200px;
                                  width: fit-content;
                                  right: -185px;
                                  /* background-color: red; */
                                  /* z-index: 111; */
                                  /* padding: 0 10px; */
                                }
                                .range_page .sliderValue span.show {
                                  transform: translateX(50%) scale(1);
                                }
                                .range_page .sliderValue span {
                                  position: absolute;
                                  height: 45px;
                                  color: white;
                                  font-weight: 500;
                                  transform: translateX(50%) scale(0);
                                  transform-origin: bottom;
                                  transition: transform 0.3s ease-in-out;
                                  line-height: 15px;
                                  z-index: 2;
                                  top: -30px;
                                  width: 30px;
                                  right: 19px;
                                  text-align: center;
                                  font-size: 11px !important;
                                }
                                .range_page .field input {
                                  -webkit-appearance: none;
                                  direction: rtl;
                                  height: 5px;
                                  background: #dcddd5;
                                  border-radius: 5px;
                                  outline: none;
                                  border: none;
                                  width: 400px;
                                  margin: 0 5px;
                                }
                                .range_page .sliderValue span:after {
                                  position: absolute;
                                  content: "";
                                  height: 30px;
                                  width: 30px;
                                  background: #4a6868;
                                  left: 50%;
                                  transform: translateX(-50%) rotate(45deg);
                                  z-index: -1;
                                  border-top-left-radius: 50%;
                                  border-top-right-radius: 50%;
                                  border-bottom-left-radius: 50%;
                                  top: -10px;
                                }
                                .range_page .field .value {
                                  position: absolute;
                                  font-size: 18px;
                                  font-weight: 600;
                                  color: black;
                                }
                                .range_page .field {
                                  position: relative;
                                  display: flex;
                                  align-items: center;
                                  justify-content: center;
                                  height: 100%;
                                }
                                .range_page .field .max-value {
                                  font-size: 24px;
                                }
                                .range_page .field input[type="range"]::-webkit-slider-,
                                .range_page .field input[type="range"]::-moz-range-thumb {
                                  -webkit-appearance: none;
                                  height: 12px;
                                  width: 12px;
                                  border: 1px solid #fff;
                                  background: #4a6c6d !important;
                                  border-radius: 50%;
                                  cursor: pointer;
                                }




                                .tooltip-inner {
                                  background-color: #4a6868 !important;
                                  color: #fff !important;
                                  min-width: fit-content;
                                  max-width: 50vw;
                                  text-align: justify;
                                  font-size: 14px !important;
                                  font-family: "lotus-light" !important;
                                }
                                .bs-tooltip-auto[data-popper-placement^="top"] .tooltip-arrow::before,
                                .bs-tooltip-top .tooltip-arrow::before {
                                border-top-color: #4a6868 !important;
                                }

                                .bs-tooltip-auto[data-popper-placement^="right"] .tooltip-arrow::before,
                                .bs-tooltip-top .tooltip-arrow::before {
                                border-right-color: #4a6868 !important;
                                }

                                .bs-tooltip-auto[data-popper-placement^="bottom"] .tooltip-arrow::before,
                                .bs-tooltip-top .tooltip-arrow::before {
                                border-bottom-color: #4a6868 !important;
                                }

                                .bs-tooltip-auto[data-popper-placement^="left"] .tooltip-arrow::before,
                                .bs-tooltip-top .tooltip-arrow::before {
                                border-left-color: #4a6868 !important;
                                }

                              ''';
  return style;
}
