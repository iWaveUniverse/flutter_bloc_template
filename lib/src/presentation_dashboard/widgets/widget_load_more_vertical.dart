// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// typedef ItemBuilder<T> = Widget Function(int index);

// /*

//     ===== View =====
//     WidgetLoadMoreWrapVertical<ForumPostModel>.build(
//       key: _viewModel.keyListView,
//       padding: const EdgeInsets.only(
//           bottom: NavigationScreen.HEIGHT_BOTTOM_NAV_TOTAL + 10,
//           top: 10),
//       itemBuilder: _buildItemForum,
//       dataRequester: _viewModel.dataRequester,
//       initRequester: _viewModel.initRequester)

//     ===== ViewModel =====
//     //Key for manage state in widget
//     final GlobalKey<WidgetLoadMoreWrapVerticalState> keyLoadMoreWrapVertical = GlobalKey();

//     Future<List<ForumPostModel>> initRequester() async {
//       return await getForumPosts(0);
//     }

//     Future<List<ForumPostModel>> dataRequester(int offset) async {
//       return await getForumPosts(offset);
//     }

//     getForumPosts(int offset) async {
//       List<ForumPostModel> data = List<ForumPostModel>();
//       NetworkState<List<ForumPostModel>> networkState =
//           await forumRepository.getForumPostByCategory(
//               offset: offset,
//               categoryID: currentCategorySubject.value?.loaikynangId);
//       if (networkState.isSuccess && networkState.data != null)
//         data = networkState.data;
//       await Future.delayed(Duration(milliseconds: 500));
//       return data;
//     }
//  */

// class WidgetLoadMoreVertical<T> extends StatefulWidget {
//   const WidgetLoadMoreVertical.build({
//     Key? key,
//     required this.items,
//     required this.itemBuilder,
//     required this.onLoading,
//     required this.onRefresh,
//     this.header,
//     this.footer,
//   }) : super(key: key);

//   final List items;
//   final ItemBuilder itemBuilder;
//   final VoidCallback onLoading;
//   final VoidCallback onRefresh;
//   final Widget? header;
//   final Widget? footer;

//   @override
//   State createState() => WidgetLoadMoreVerticalState<T>();
// }

// class WidgetLoadMoreVerticalState<T> extends State<WidgetLoadMoreVertical> {
//   bool isPerformingRequest = false;
//   final ScrollController _controller = ScrollController();

//   List get _dataList => widget.items;

//   @override
//   void initState() {
//     super.initState();
//     onRefresh();
//     _controller.addListener(() {
//       if (_controller.position.pixels == _controller.position.maxScrollExtent) {
//         _loadMore();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Color loadingColor = Colors.red;
//     return RefreshIndicator(
//       color: loadingColor,
//       onRefresh: onRefresh,
//       child: ListView.builder(
//         itemCount: _dataList.length + 1,
//         itemBuilder: (context, index) {
//           if (index == _dataList.length) {
//             return opacityLoadingProgress(isPerformingRequest, loadingColor);
//           } else {
//             return widget.itemBuilder(index);
//           }
//         },
//         controller: _controller,
//         padding: const EdgeInsets.all(0),
//       ),
//     );
//   }

//   Future<void> onRefresh() async {
//     if (mounted) {
//       widget.onRefresh();
//     }
//     return;
//   }

//   _loadMore() async {
//     if (mounted) {
//       setState(() => isPerformingRequest = true);
//       widget.onLoading();
//       if (mounted) setState(() => isPerformingRequest = false);
//     }
//   }

//   Widget loadingProgress(loadingColor) {
//     return Center(
//       child: CircularProgressIndicator(
//         strokeWidth: 2.0,
//         valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
//       ),
//     );
//   }

//   Widget opacityLoadingProgress(isPerformingRequest, loadingColor) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Center(
//         child: Opacity(
//           opacity: isPerformingRequest ? 1.0 : 0.0,
//           child: CircularProgressIndicator(
//             strokeWidth: 2.0,
//             valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
//           ),
//         ),
//       ),
//     );
//   }
// }
