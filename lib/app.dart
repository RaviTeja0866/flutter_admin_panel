import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/bindings/general_bindings.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/routes/app_routes.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'common/widgets/containers/rounded_container.dart';
import 'utils/constants/text_strings.dart';
import 'utils/device/web_material_scroll.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: RSTexts.appName,
      themeMode: ThemeMode.light,
      theme: RSAppTheme.lightTheme,
      darkTheme: RSAppTheme.darkTheme,
      getPages: RSAppRoute.pages,
      initialBinding: GeneralBindings(),
      initialRoute: RSRoutes.login,
      unknownRoute: GetPage(name: '/page-not-found', page: ()=> const Scaffold(body: Center(child: Text('Page Not Found')))),
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}

class ResponsiveDesignScreen extends StatelessWidget {
  const ResponsiveDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RSSiteTemplate(desktop: Desktop(), tablet: Tablet(), mobile: Mobile(),);
  }
}

class Desktop extends StatelessWidget {
  const Desktop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            /// First Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RSRoundedContainer(
                    height: 450,
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    child: const Center(child: Text('Box1')),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      RSRoundedContainer(
                        height: 215,
                        backgroundColor: Colors.orange.withOpacity(0.2),
                        child: const Center(child: Text('Box2')),
                      ),
                      const SizedBox(height: 20),

                      /// Second row
                      Row(
                        children: [
                          Expanded(
                            child: RSRoundedContainer(
                              height: 215,
                              backgroundColor: Colors.green.withOpacity(0.2),
                              child: const Center(child: Text('Box3')),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: RSRoundedContainer(
                              height: 215,
                              backgroundColor: Colors.purple.withOpacity(0.2),
                              child: const Center(child: Text('Box4')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 20),

            /// Second Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: RSRoundedContainer(
                    height: 190,
                    backgroundColor: Colors.red.withOpacity(0.2),
                    child: const Center(child: Text('Box5')),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: RSRoundedContainer(
                    height: 190,
                    backgroundColor: Colors.red.withOpacity(0.2),
                    child: const Center(child: Text('Box6')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Tablet extends StatelessWidget {
  const Tablet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Add a scrollable container
      child: Column(
        children: [
          /// First Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RSRoundedContainer(
                  height: 450,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  child: const Center(child: Text('Box1')),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    RSRoundedContainer(
                      height: 215,
                      backgroundColor: Colors.orange.withOpacity(0.2),
                      child: const Center(child: Text('Box2')),
                    ),
                    const SizedBox(height: 20),

                    /// Second row
                    Row(
                      children: [
                        Expanded(
                          child: RSRoundedContainer(
                            height: 215,
                            backgroundColor: Colors.green.withOpacity(0.2),
                            child: const Center(child: Text('Box3')),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: RSRoundedContainer(
                            height: 215,
                            backgroundColor: Colors.purple.withOpacity(0.2),
                            child: const Center(child: Text('Box4')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 20),

          /// Second Row
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RSRoundedContainer(
                height: 190,
                width: double.infinity,
                backgroundColor: Colors.red.withOpacity(0.2),
                child: const Center(child: Text('Box5')),
              ),
              const SizedBox(height: 20),
              RSRoundedContainer(
                height: 190,
                width: double.infinity,
                backgroundColor: Colors.red.withOpacity(0.2),
                child: const Center(child: Text('Box6')),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class Mobile extends StatelessWidget {
  const Mobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// First Row
        RSRoundedContainer(
          height: 450,
          width: double.infinity,
          backgroundColor: Colors.blue.withOpacity(0.2),
          child: const Center(child: Text('Box1')),
        ),
        const SizedBox(height: 20),
        RSRoundedContainer(
          height: 215,
          width: double.infinity,
          backgroundColor: Colors.orange.withOpacity(0.2),
          child: const Center(child: Text('Box2')),
        ),
        const SizedBox(height: 20),
        RSRoundedContainer(
          height: 215,
          width: double.infinity,
          backgroundColor: Colors.red.withOpacity(0.2),
          child: const Center(child: Text('Box3')),
        ),
        const SizedBox(height: 20),
        RSRoundedContainer(
          height: 215,
          width: double.infinity,
          backgroundColor: Colors.green.withOpacity(0.2),
          child: const Center(child: Text('Box4')),
        ),
        const SizedBox(height: 20),

        ///Second Row
        RSRoundedContainer(
          height: 190,
          backgroundColor: Colors.green.withOpacity(0.2),
          child: const Center(child: Text('Box5')),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
